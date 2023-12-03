# frozen_string_literal: true

example = <<~EXMP
  467..114..
  ..*.......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day03.txt"))
# input = example

numbers = []
part_markers = []
parts_by_marker = {}

# Parse world, catalogue all numbers and "markers" in the process
lines = input.split("\n")
lines.each_with_index do |r, r_idx|
  begins_at = -1
  num_parts = []
  r.split("").each_with_index do |c, c_idx|
    if c =~ /\d/
      # Numbers:
      begins_at = c_idx if num_parts.empty?
      num_parts << c
    elsif c != "." && c !~ /\d/
      # Part markers:
      part_markers << { symbol: c, row: r_idx, col: c_idx }
    end

    if c !~ /\d/
      unless num_parts.empty?
        numbers << { number: num_parts.join('').to_i, row: r_idx, begins_at: }
        num_parts = []
        begins_at = -1
      end
    end
  end

  unless num_parts.empty?
    numbers << { number: num_parts.join('').to_i, row: r_idx, begins_at: }
  end
end

# Decide which numbers represent parts
numbers.each do |num|
  number = num[:number]
  row = num[:row]
  begins_at = num[:begins_at]

  markers_same_row = part_markers.select { |p| p[:row] == row }
  markers_above_row = part_markers.select { |p| p[:row] == row - 1 }
  markers_below_row = part_markers.select { |p| p[:row] == row + 1 }

  adjacent_markers = []

  adjacent_markers << markers_same_row.select do |p|
    p[:col] == begins_at - 1 ||
      p[:col] == begins_at + number.to_s.length
  end

  adjacent_markers << (markers_above_row + markers_below_row).select do |p|
    p[:col] >= begins_at - 1 &&
      p[:col] <= begins_at + number.to_s.length
  end

  adjacent_markers.flatten!
  if adjacent_markers.any?
    adjacent_markers.each do |am|
      parts_by_marker[[am[:row], am[:col]]] ||= []
      parts_by_marker[[am[:row], am[:col]]] << number
    end
  end
end

gears = parts_by_marker.select { |_, v| v.count == 2 }
multiplied_gears = gears.map { |_, v| v.inject(:*) }

puts multiplied_gears.sum

