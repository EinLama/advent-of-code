# frozen_string_literal: true

module Aoc2022
  module Day2
    class Rock
      include Comparable

      def score
        1
      end

      def self.nemesis
        Paper
      end

      def <=>(other)
        case other
        when Paper
          -1
        when Scissors
          1
        else
          0
        end
      end
    end

    class Paper
      include Comparable

      def score
        2
      end

      def self.nemesis
        Scissors
      end

      def <=>(other)
        case other
        when Scissors
          -1
        when Rock
          1
        else
          0
        end
      end
    end

    class Scissors
      include Comparable

      def score
        3
      end

      def self.nemesis
        Rock
      end

      def <=>(other)
        case other
        when Rock
          -1
        when Paper
          1
        else
          0
        end
      end
    end

    module_function

    def from_lines(str, guess_response: false)
      str.split("\n").map { |l| from_line(l, guess_response: guess_response) }
    end

    def from_line(str, guess_response: false)
      them = { "A" => Rock, "B" => Paper, "C" => Scissors }
      ours = { "X" => Rock, "Y" => Paper, "Z" => Scissors }

      sp = str.split(" ")
      contrahent = them[sp[0]]

      mine = if guess_response
               case sp[1]
               when "X"
                 contrahent.nemesis.nemesis
               when "Y"
                 contrahent
               when "Z"
                 contrahent.nemesis
               end
             else
               ours[sp[1]]
             end

      [contrahent.new, mine.new]
    end

    def play!(them:, ours:)
      if ours > them
        ours.score + 6
      elsif ours < them
        ours.score
      else
        ours.score + 3
      end
    end

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      plays = from_lines(input)

      plays.map do |them, ours|
        play!(them: them, ours: ours)
      end.sum
    end

    def solve_part2(input)
      plays = from_lines(input, guess_response: true)

      plays.map do |them, ours|
        play!(them: them, ours: ours)
      end.sum
    end
  end
end
