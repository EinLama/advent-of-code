# frozen_string_literal: true

example = <<~EXMP
    .M.S......
  ..A..MSMS.
  .M.S.MAA..
  ..A.ASMSM.
  .M.S.M....
  ..........
  S.S.S.S.S.
  .A.A.A.A..
  M.M.M.M.M.
  ..........
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

def xmas?(map, x, y)
  nwse = (map[x - 1][y - 1] == "M" &&
    map[x + 1][y + 1] == "S") ||
         (map[x - 1][y - 1] == "S" &&
           map[x + 1][y + 1] == "M")

  nesw = (map[x + 1][y - 1] == "M" &&
    map[x - 1][y + 1] == "S") ||
         (map[x + 1][y - 1] == "S" &&
           map[x - 1][y + 1] == "M")

  nwse && nesw
end

def trace_xmas(map, x, y)
  return 0 if map[x][y] == "-"

  if map[x][y] == "A"
    xmas?(map, x, y) ? 1 : 0
  else
    0
  end
end

add_buffer map
# pmap map

puts search_xmas(map)
