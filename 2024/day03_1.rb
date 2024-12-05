# frozen_string_literal: true

example = <<~EXMP
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day03.txt"))
# input = example

def extract_ops(str)
  str.scan(/mul\((\d+),(\d+)\)/)
end

ops = input.each_line.map do |line|
  extract_ops(line).flatten.map(&:to_i)
end.flatten.each_slice(2).to_a

pp ops.inject(0) { |sum, (a, b)| sum + a * b }
