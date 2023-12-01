# frozen_string_literal: true

require "set"

module Aoc2022
  module Day9
    class Rope
      attr_accessor :head, :tail, :past_positions

      def initialize
        @head = [0, 0]
        @tail = [0, 0]
        @past_positions = Set.new

        move([0, 0])
        remember_tail
      end

      def length
        [@head.first - @tail.first, @head.last - @tail.last].map(&:abs).sum
      end

      def adjacent?
        # directly adjacent:
        return true if length <= 1

        # diagonal
        [@head.first - @tail.first, @head.last - @tail.last].map(&:abs) == [1, 1]
      end

      def move(new_position)
        x, y = new_position

        if x.positive?
          x.times do
            move_right
            drag_tail
          end
        elsif x.negative?
          x.abs.times do
            move_left
            drag_tail
          end
        end

        if y.positive?
          y.times do
            move_down
            drag_tail
          end
        elsif y.negative?
          y.abs.times do
            move_up
            drag_tail
          end
        end
      end

      def remember_tail
        @past_positions.add @tail
      end

      def move_up
        @head = [@head.first, @head.last - 1]
      end

      def move_right
        @head = [@head.first + 1, @head.last]
      end

      def move_down
        @head = [@head.first, @head.last + 1]
      end

      def move_left
        @head = [@head.first - 1, @head.last]
      end

      def distinct_tail_positions
        @past_positions.count
      end

      private

      def drag_tail
        return if adjacent?

        hx, hy = @head
        tx, ty = @tail

        if hx > tx
          tx += 1
        elsif hx < tx
          tx -= 1
        end

        if hy > ty
          ty += 1
        elsif hy < ty
          ty -= 1
        end

        @tail = [tx, ty]
        remember_tail
      end
    end

    module_function

    def parse_directions(input)
      input.scan(/\w \d+/).map do |n|
        dir, num = n.split(" ")

        case dir
        when "R"
          [num.to_i, 0]
        when "L"
          [num.to_i * -1, 0]
        when "U"
          [0, num.to_i * -1]
        when "D"
          [0, num.to_i]
        end
      end
    end

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      steps = parse_directions(input)

      rope = Rope.new
      steps.each do |s|
        rope.move(s)
      end

      rope.distinct_tail_positions
    end

    def solve_part2(input); end
  end
end
