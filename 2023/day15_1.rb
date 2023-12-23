# frozen_string_literal: true

example = <<~EXMP
  rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day15.txt"))
# input = example


def hash_algorithm(current_value, next_char)
  current_value += next_char.ord
  current_value *= 17
  current_value % 256
end

results = []

input.chomp.split(",").each do |seq|
  current_value = 0
  seq.each_char do |c|
    current_value = hash_algorithm(current_value, c)
  end
  results << current_value
end

# pp results
pp results.sum
