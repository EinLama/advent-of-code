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

input.each_line do |line|
  l, r = left_and_right_number(line)

  left << l
  right << r
end

right_t = right.tally

t = left.inject(0) do |total, i|
  n = right_t.fetch(i, 0)
  (total + n * i).to_i
end

puts t