# frozen_string_literal: true

module Aoc2022
  module Day10
    class Cpu
      def initialize
        @x = 1
        @cycles = [state]
      end

      def cycle_count
        @cycles.size - 1
      end

      def register_x
        @x
      end

      def after_cycle(cycle)
        @cycles[cycle]
      end

      def state
        { x: @x }
      end

      def signal_strength_after_cycle(c)
        after_cycle(c - 1)[:x] * c
      end

      def exec(instruction)
        instr, value = instruction

        case instr
        when "noop"
          @cycles << state
        when "addx"
          @cycles << state
          @x += value
          @cycles << state
        end
      end
    end

    module_function

    def parse_input(str)
      str.scan(/\w+ -?\d+|noop/).map do |p|
        i, n = p.split(" ")
        if n
          [i, n.to_i]
        else
          [i]
        end
      end
    end

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      instr = parse_input(input)

      cpu = Cpu.new
      instr.each do |i|
        cpu.exec(i)
      end

      [20, 60, 100, 140, 180, 220].map do |c|
        cpu.signal_strength_after_cycle(c)
      end.sum
    end

    def solve_part2(input); end
  end
end
