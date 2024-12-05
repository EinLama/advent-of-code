# frozen_string_literal: true

example = <<~EXMP
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day03.txt"))
# input = example

def extract_do_dont(str)
  str.split(/(do\(\))|(don't\(\))/)
end

def extract_mul(str)
  str.scan(/mul\((\d+),(\d+)\)/)
end

total = 0
active = true
do_dont = extract_do_dont(input)

do_dont.each do |i|
  if i == "don't()"
    active = false
    next
  elsif i == "do()"
    active = true
    next
  else
    extract_mul(i).each do |a, b|
      total += a.to_i * b.to_i if active
    end
  end
end

p total
