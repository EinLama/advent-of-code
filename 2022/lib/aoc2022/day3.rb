# frozen_string_literal: true

module Aoc2022
  module Day3
    class Rucksack
      def initialize(contents)
        @contents = contents
      end

      def compartments
        unless @compartments
          half = @contents.length / 2
          @compartments = [@contents[0...half], @contents[half...@contents.length]]
        end

        @compartments
      end

      def find_dups
        first, second = compartments

        first.split("").find do |c|
          second.include?(c)
        end
      end
    end

    module_function

    def priority(letter)
      if letter.ord >= 97
        letter.ord - 96
      else
        letter.ord - 38
      end
    end

    def group_badge(lines)
      first, second, third = lines
      first.split("").find do |c|
        second.include?(c) && third.include?(c)
      end
    end

    def build_rucksacks(input)
      input.split("\n").map do |line|
        Rucksack.new(line)
      end
    end

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      rucksacks = build_rucksacks(input)

      rucksacks.map do |r|
        priority(r.find_dups)
      end.sum
    end

    def solve_part2(input)
      input.split("\n").each_slice(3).map do |g|
        priority(group_badge(g))
      end.sum
    end
  end
end
