# frozen_string_literal: true

module Aoc2022
  module Day4
    module_function

    def pairs(str)
      pairs = str.split(",")

      pairs.map do |p|
        a, b = p.split("-").map(&:to_i)
        a..b
      end
    end

    def overlap?(a, b)
      a.min >= b.min && a.max <= b.max ||
        b.min >= a.min && b.max <= a.max
    end

    def partial_overlap?(a, b)
      a.any? { |n| b.include?(n) }
    end

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      input.each_line.filter do |line|
        overlap?(*pairs(line))
      end.count
    end

    def solve_part2(input)
      input.each_line.filter do |line|
        partial_overlap?(*pairs(line))
      end.count
    end
  end
end
