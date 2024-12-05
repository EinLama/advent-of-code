# frozen_string_literal: true

# example = <<~EXMP
#   ....XXMAS.
#   .SAMXMS...
#   ...S..A...
#   ..A.A.MS.X
#   XMASAMX.MM
#   X.....XA.A
#   S.S.S.S.SS
#   .A.A.A.A.A
#   ..M.M.M.MM
#   .X.X.XMASX
# EXMP

example = <<~EXMP
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
EXMP


input = File.read(File.join(File.dirname(__FILE__), "day04.txt"))
# input = example

map = input.split.map { _1.split("") }

def add_buffer(map)
  row_size = map.first.length + 3 * 2

  map.each do |row|
    3.times { row.unshift("-") }
    3.times { row << "-" }
  end

  # top
  3.times { map.unshift(Array.new(row_size, "-")) }
  # bot
  3.times { map << Array.new(row_size, "-") }
end

def pmap(map)
  map.each do |r|
    r.each do |c|
      print c
    end
    puts
  end
end

def search_xmas(map)
  total = 0
  map.each_with_index do |r, i|
    r.each_with_index do |c, j|
      total += trace_xmas(map, i, j)
    end
  end

  total
end

def xmas?(map, x, y, dir=:n)
  case dir
  when :n
    map[x][y - 1] == "M" &&
      map[x][y - 2] == "A" &&
      map[x][y - 3] == "S"
  when :s
    map[x][y + 1] == "M" &&
      map[x][y + 2] == "A" &&
      map[x][y + 3] == "S"
  when :e
    map[x + 1][y] == "M" &&
      map[x + 2][y] == "A" &&
      map[x + 3][y] == "S"
  when :w
    map[x - 1][y] == "M" &&
      map[x - 2][y] == "A" &&
      map[x - 3][y] == "S"
  when :nw
    map[x - 1][y - 1] == "M" &&
      map[x - 2][y - 2] == "A" &&
      map[x - 3][y - 3] == "S"
  when :ne
    map[x + 1][y - 1] == "M" &&
      map[x + 2][y - 2] == "A" &&
      map[x + 3][y - 3] == "S"
  when :sw
    map[x - 1][y + 1] == "M" &&
      map[x - 2][y + 2] == "A" &&
      map[x - 3][y + 3] == "S"
  when :se
    map[x + 1][y + 1] == "M" &&
      map[x + 2][y + 2] == "A" &&
      map[x + 3][y + 3] == "S"
  else
    raise "unknown direction"
  end
end

def trace_xmas(map, x, y)
  return 0 if map[x][y] == "-"

  if map[x][y] == "X"
    directions = %i[n e s w ne nw se sw]

    directions.map do |dir|
      xmas?(map, x, y, dir)
    end.count(true)
  else
    0
  end
end

add_buffer map
# pmap map

puts search_xmas(map)
