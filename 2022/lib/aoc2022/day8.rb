# frozen_string_literal: true

require "colorize"

module Aoc2022
  module Day8
    class World
      def initialize(str)
        @map = str.split("\n").map do |line|
          line.split("").map(&:to_i)
        end
      end

      def width
        @map.first.length
      end

      def height
        @map.length
      end

      def tree_at(x, y)
        @map[y][x]
      end

      def scenic_score(x, y)
        tree = tree_at(x, y)

        vd_left = []
        (0...x).to_a.reverse.each do |c|
          local_tree = tree_at(c, y)
          vd_left << local_tree

          break unless tree > local_tree
        end

        vd_right = []
        ((x + 1)...width).each do |c|
          local_tree = tree_at(c, y)
          vd_right << local_tree

          break unless tree > local_tree
        end

        vd_top = []
        (0...y).to_a.reverse.each do |c|
          local_tree = tree_at(x, c)
          vd_top << local_tree

          break unless tree > local_tree
        end

        vd_bot = []
        ((y + 1)...height).each do |c|
          local_tree = tree_at(x, c)
          vd_bot << local_tree

          break unless tree > local_tree
        end

        # puts "FOUND DISTANCES: #{vd_top}, #{vd_left}, #{vd_right}, #{vd_bot}"

        vd_left.size * vd_right.size * vd_bot.size * vd_top.size
      end

      def best_scenic_spot
        highest_score = 0
        (1...(width - 1)).each do |x|
          (1...(height - 1)).each do |y|
            highest_score = [highest_score, scenic_score(x, y)].max
          end
        end

        highest_score
      end

      def count_visible_trees
        trees = 0
        (0...width).each do |x|
          (0...height).each do |y|
            trees += 1 if tree_visible?(x, y)
          end
        end

        trees
      end

      def tree_visible?(x, y)
        mytree = tree_at(x, y)

        check_left(mytree, x, y) || check_right(mytree, x, y) ||
          check_top(mytree, x, y) || check_bottom(mytree, x, y)
      end

      def check_left(tree, x, y)
        return true if x.zero?

        (0...x).all? { |c| tree > tree_at(c, y) }
      end

      def check_right(tree, x, y)
        return true if x >= width - 1

        ((x + 1)...width).all? { |c| tree > tree_at(c, y) }
      end

      def check_top(tree, x, y)
        return true if y.zero?

        (0...y).all? { |c| tree > tree_at(x, c) }
      end

      def check_bottom(tree, x, y)
        return true if y >= height - 1

        ((y + 1)...height).all? { |c| tree > tree_at(x, c) }
      end

      def print_map(with_visibles: false)
        (0...height).each do |y|
          (0...width).each do |x|
            tree = tree_at(x, y)
            if with_visibles && tree_visible?(x, y)
              print tree.to_s.green
            else
              print tree
            end
          end
          puts
        end
      end
    end

    module_function

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      world = World.new(input)
      world.print_map(with_visibles: true)
      puts "-----------------"

      world.count_visible_trees
    end

    def solve_part2(input)
      world = World.new(input)

      world.best_scenic_spot
    end
  end
end
