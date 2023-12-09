# frozen_string_literal: true

example = <<~EXMP
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day08.txt"))
# input = example

lines = input.split("\n")
instructions = lines.first.split("")

world = lines.slice(2, lines.size).map do |l|
  current, left, right = l.scan(/(\w{3}) = \((\w{3}), (\w{3})\)/).flatten
  [current, [left, right]]
end.to_h

steps_taken = 0
current_position = "AAA"

instructions.cycle do |instr|
  break if current_position == "ZZZ"

  possible_ways = world[current_position]
  current_position = instr == "L" ? possible_ways.first : possible_ways.last
  steps_taken += 1
end

pp steps_taken