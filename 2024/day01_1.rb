# frozen_string_literal: true

example = <<-EXMP
3   4
4   3
2   5
1   3
3   9
3   3
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day01.txt"))
# input = example

left = []
right = []

def left_and_right_number(line)
  numbers = line.scan(/(\d+)\s+(\d+)/).flatten
  [numbers.first.to_i, numbers.last.to_i]
end

def distance(a, b)
  (a - b).abs
end

input.each_line do |line|
  l, r = left_and_right_number(line)

  left << l
  right << r
end

combined = left.sort.zip(right.sort)
distances = combined.map do |n|
  distance(n[0], n[1])
end

# pp distances
puts distances.inject(:+)