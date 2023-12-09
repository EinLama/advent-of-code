# frozen_string_literal: true

example = <<~EXMP
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day08.txt"))
# input = example

lines = input.split("\n")
instructions = lines.first.split("")

world = lines.slice(2, lines.size).map do |l|
  current, left, right = l.scan(/(\w{3}) = \((\w{3}), (\w{3})\)/).flatten
  [current, [left, right]]
end.to_h

def take_next_step(current_positions, world, instruction)
  current_positions.map do |current_position|
    possible_ways = world[current_position]
    instruction == "L" ? possible_ways.first : possible_ways.last
  end
end

current_positions = world.keys.select { _1.end_with?("A") }
end_positions = current_positions.map { [_1, 0] }.to_h

pp current_positions

current_positions.each do |curr_pos|
  steps_taken = 0
  current_position = curr_pos

  instructions.cycle do |instr|
    if curr_pos.end_with?("Z")
      # Remember the step count for each starting-position:
      end_positions[current_position] = steps_taken
      break
    end

    possible_ways = world[curr_pos]
    curr_pos = instr == "L" ? possible_ways.first : possible_ways.last

    steps_taken += 1
  end
end

puts

pp end_positions
# Find the lowest common multiplier of all paths and hope this works:
pp end_positions.values.reduce(&:lcm)
