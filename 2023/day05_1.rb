# frozen_string_literal: true

example = <<~EXMP
  seeds: 79 14 55 13

  seed-to-soil map:
  50 98 2
  52 50 48

  soil-to-fertilizer map:
  0 15 37
  37 52 2
  39 0 15

  fertilizer-to-water map:
  49 53 8
  0 11 42
  42 0 7
  57 7 4

  water-to-light map:
  88 18 7
  18 25 70

  light-to-temperature map:
  45 77 23
  81 45 19
  68 64 13

  temperature-to-humidity map:
  0 69 1
  1 0 69

  humidity-to-location map:
  60 56 37
  56 93 4
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day05.txt"))
# input = example

class DataHash
  def initialize(src = nil, dst = nil, range = nil)
    @ranges = []

    add_range(src, dst, range) if src
  end

  def add_range(src, dst, range)
    @ranges << [src, dst, range]
  end

  def [](id)
    @ranges.each do |range|
      src, dst, len = range
      if id >= src && id < src + len
        diff = src - id

        return dst + diff.abs
      end
    end

    id
  end
end

data = {}
current_marker = nil

input.split("\n").each do |line|
  if line.start_with?("seeds: ")
    data[:seeds] = line.scan(/\d+/).map(&:to_i)
  elsif line =~ / map:$/
    marker = line.split(" ").first.gsub("-", "_")
    current_marker = marker
    data[current_marker] ||= DataHash.new
  elsif line.empty?
    current_marker = nil
  elsif current_marker
    # line for current marker, add data
    dst_start, src_start, range_len = line.split(" ").map(&:to_i)

    data[current_marker].add_range(src_start, dst_start, range_len)
  end
end

puts "done parsing..."

def find_location(data, start_id, start_key = "seed")
  cur_key = start_key
  cur_id = start_id

  loop do
    # puts "searching for #{cur_key} #{cur_id}"
    next_store = data.find { |k, _v| k.start_with? "#{cur_key}_to" }
    store_name, store_values = next_store
    # pp store_name
    next_id = store_values[cur_id]
    next_key = store_name.sub("#{cur_key}_to_", "")
    # puts "#{cur_key} #{cur_id} mapped to #{next_key} #{next_id}"

    if next_key == "location"
      return next_id # final value
    else
      cur_key = next_key
      cur_id = next_id
    end
  end
end

# [98, 99, 53, 300].each do |seed|
#   puts "Seed id #{seed} maps to #{data["seed_to_soil"][seed]}"
#   puts "------------------"
# end

all_locations = data[:seeds].map { find_location(data, _1) }
puts all_locations.min

