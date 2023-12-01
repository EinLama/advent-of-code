# frozen_string_literal: true

module Aoc2022
  module Day1
    class Elf
      attr_reader :calories

      def self.from_str(str)
        elves = []

        nums = 0
        str.split("\n").each do |line|
          if line.empty?
            elves << Elf.new(calories: nums)
            nums = 0
          end
          nums += line.to_i
        end
        elves << Elf.new(calories: nums)

        elves
      end

      def initialize(calories: 0)
        @calories = calories
      end
    end

    module_function

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      elves = Elf.from_str(input)

      # Top calory count:
      elves.max_by(&:calories).calories
    end

    def solve_part2(input)
      elves = Elf.from_str(input)

      # Sum of the top three calory counts:
      elves.sort_by(&:calories).reverse.take(3).sum(&:calories)
    end
  end
end
