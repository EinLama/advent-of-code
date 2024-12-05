# frozen_string_literal: true

example = <<~EXMP
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day02.txt"))
# input = example

def report_safe?(report)
  dir = report[0] < report[1] ? :asc : :desc

  report.each_cons(2) do |a, b|
    return false if dir == :asc && a > b
    return false if dir == :desc && a < b
    return false if a == b || (a - b).abs > 3
  end

  true
end

# Naive approach. First tried to begin at the first malfunctioning index,
# but this didn't catch for one report. Didn't bother to debug why exactly this
# happened as the brute force fix worked.
def report_mutation_safe?(report)
  (0..report.length - 1).each do |idx|
    copy = report.dup
    copy.delete_at(idx)
    return true if report_safe?(copy)
  end

  false
end

reports = input.each_line.map do |line|
  line.split.map(&:to_i)
end

safe_reports = reports.count do |r|
  report_safe?(r) || report_mutation_safe?(r)
end

pp safe_reports
