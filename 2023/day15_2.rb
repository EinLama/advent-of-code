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

def render_boxes(boxes)
  boxes.each_with_index do |box, i|
    if box
      print "Box #{i}: "
      pp box.map { _1.join("=") }
    end
  end
end

results = []
boxes = Array.new(256)

input.chomp.split(",").each do |seq|
  current_value = 0

  label, instr = seq.split(/[=-]/)

  label.each_char do |c|
    current_value = hash_algorithm(current_value, c)
  end

  results << { seq:, label:, instr:, hash_value: current_value }

  box = boxes[current_value]
  box ||= []

  idx = box.index { _1.first == label }
  if instr.nil?
    box.delete_at(idx) if idx
  elsif idx
    b = box[idx]
    b[1] = instr
  else
    box << [label, instr]
  end

  boxes[current_value] = box

  # puts "after #{seq}"
  # render_boxes boxes
  # puts "========================="
end

# render_boxes boxes

def end_result(boxes)
  sum = 0
  boxes.each_with_index do |box, slot|
    box ||= []
    box.each_with_index do |entry, e_slot|
      sum += (1 + slot) * (e_slot + 1) * entry.last.to_i
    end
  end

  sum
end

pp end_result(boxes)