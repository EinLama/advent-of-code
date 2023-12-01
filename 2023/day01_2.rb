# frozen_string_literal: true

example = <<-EXMP
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day01.txt"))
# input = example

STR_WORDS = {
  "one" => 1,
  "two" => 2,
  "three" => 3,
  "four" => 4,
  "five" => 5,
  "six" => 6,
  "seven" => 7,
  "eight" => 8,
  "nine" => 9
}

PATTERN = /\d|#{STR_WORDS.keys.join("|")}/

def first_and_last_digit_or_word(line)
  numbers = line.scan(PATTERN).map { |n| STR_WORDS[n] || n }
  [numbers.first, numbers.last]
end

all_nums_in_input = input.split.map do |line|
  first_and_last_digit_or_word(line).join("").to_i
end

puts all_nums_in_input.sum
