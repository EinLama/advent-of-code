# frozen_string_literal: true

example = <<~EXMP
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
EXMP

# input = File.read(File.join(File.dirname(__FILE__), "day02.txt"))
input = example

def report_safe?(report)
  sorted = report.sort
  return false if sorted != report && sorted != report.reverse

  report.each_cons(2) do |a, b|
    return false if a == b || (a - b).abs > 3
  end

  true
end

reports = input.each_line.map do |line|
  line.split.map(&:to_i)
end

safe_reports = reports.count { |r| report_safe?(r) }
pp safe_reports
