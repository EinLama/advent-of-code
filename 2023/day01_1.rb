# frozen_string_literal: true

example = <<-EXMP
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day01.txt"))
# input = example

def first_and_last_digit(line)
  numbers = line.scan(/\d/)
  [numbers.first, numbers.last]
end

all_nums_in_input = input.split.map do |line|
  first_and_last_digit(line).join("").to_i
end

puts all_nums_in_input.sum
