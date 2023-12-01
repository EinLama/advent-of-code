# frozen_string_literal: true

module Aoc2022
  module Day6
    module_function

    def find_marker(str, marker_length: 4)
      (str.length - marker_length).times do |i|
        s = str.slice(i, marker_length)
        return i + marker_length if s.chars.uniq == s.split("")
      end

      nil
    end

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      find_marker(input)
    end

    def solve_part2(input)
      find_marker(input, marker_length: 14)
    end
  end
end
