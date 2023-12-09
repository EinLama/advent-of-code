# frozen_string_literal: true

example = <<~EXMP
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day09.txt"))
# input = example

sequences = input.split("\n").map { _1.split.map(&:to_i) }

def next_row_for_seq(seq)
  (0...seq.length).filter_map do |i|
    i == seq.length - 1 ? nil : seq[i + 1] - seq[i]
  end
end

def find_end_row(seq)
  next_line = seq
  lines_for_seq = []
  loop do
    next_line = next_row_for_seq next_line
    lines_for_seq << next_line

    break if next_line.all?(&:zero?)
  end

  [seq, *lines_for_seq]
end

def fill_seq_up(seq)
  last_row = seq.last
  last_row.prepend(0)

  (seq.length - 2).downto(0).each do |si|
    first_entry = seq[si].first
    next_in_row = first_entry - seq[si + 1].first
    seq[si].prepend(next_in_row)
  end

  seq
end


corrected = sequences.map do |s|
  seq = find_end_row s
  fill_seq_up seq

  seq.first.first
end

pp corrected.sum
