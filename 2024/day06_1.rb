# frozen_string_literal: true

example = <<~EXMP
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day06.txt"))
# input = example

def add_buffer(map)
  row_size = map.first.length + 2

  map.each do |row|
    row.unshift("F")
    row << "F"
  end

  # top
  map.unshift(Array.new(row_size, "F"))
  # bot
  map << Array.new(row_size, "F")
end

def pmap(map)
  map.each do |r|
    r.each do |c|
      print c
    end
    puts
  end
  puts "/" * map.length
end

def find_initial_guard_pos(map)
  map.each_with_index do |r, ri|
    r.each_with_index do |c, ci|
      return ri, ci, c if c != "." && c != "#" && c != "F"
    end
  end

  raise "Guard not found"
end

class Guard
  attr_reader :glyph

  def initialize(x, y, glyph="^")
    @x = x
    @y = y
    @glyph = glyph
  end

  def direction
    @directions ||=
      {
        "^" => :up,
        "v" => :down,
        "<" => :left,
        ">" => :right
      }

    @directions[@glyph]
  end

  def move!(map)
    new_x, new_y = case direction
                   when :up
                     [@x, @y - 1]
                   when :down
                     [@x, @y + 1]
                   when :left
                     [@x - 1, @y]
                   when :right
                     [@x + 1, @y]
                   else
                     raise "Unknown direction! #{direction}"
                   end

    new_pos = map[new_y][new_x]

    if new_pos == "F"
      pmap map
      make_step(new_x, new_y, map)
      return false
    end

    if new_pos != "#"
      make_step(new_x, new_y, map)
    else
      turn_right
      move!(map)
    end

    true
  end

  def turn_right
    @turns ||= {
      up: ">",
      down: "<",
      left: "^",
      right: "v"
    }

    @glyph = @turns[direction]
  end

  def make_step(new_x, new_y, map)
    map[@y][@x] = "X" # leave trail
    @x = new_x
    @y = new_y
    map[@y][@x] = @glyph
  end
end

def count_x(map)
  total = 0
  map.each do |r|
    total += r.count("X")
  end
  total
end

map = input.split.map { _1.split("") }
add_buffer(map)

pmap map
y, x, glyph = find_initial_guard_pos(map)
guard = Guard.new(x, y, glyph)
loop do
  break unless guard.move!(map)
end

pmap map
pp count_x(map)
