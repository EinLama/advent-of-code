# frozen_string_literal: true

module Aoc2022
  module Day17
    ROCKS = <<~ROCKS
####

.#.
###
.#.

..#
..#
###

#
#
#
#

##
##
ROCKS

    module_function

    def can_move?(rock, grid, x, y)
      h = rock.length
      w = rock.first.length

      return false if y >= grid.length
      return false if x.negative? || x + w > grid[0].length

      rock.each_with_index do |row, y1|
        row.each_with_index do |cell, x1|
          if cell == "#" && grid[y - h + 1 + y1][x + x1] == "#"
            return false
          end
        end
      end

      true
    end

    def solve_example(input)
      solve_part1(input)
    end

    def solve(input, iterations=2022)
      jets = input.strip.chars

      rocks = ROCKS.split("\n\n").map do |rock|
        rock.split("\n").map(&:chars)
      end

      chamber_width = 7
      max_rock_height = rocks.map(&:length).max
      x_offset = 2
      y_offset = 4

      grid = Array.new(5) { Array.new(chamber_width, " ") }

      tower_height = 0
      jet_idx = 0

      iterations.times do |i|
        rock = rocks[i % rocks.length]

        rock_height = rock.length

        x = x_offset
        y = grid.length - tower_height - y_offset

        loop do
          move = jets[jet_idx]
          jet_idx = (jet_idx + 1) % jets.length

          case move
          when ?<
            x -= 1 if can_move?(rock, grid, x - 1, y)
          when ?>
            x += 1 if can_move?(rock, grid, x + 1, y)
          end

          if can_move?(rock, grid, x, y + 1)
            y += 1
          else
            rock.each_with_index do |row, y1|
              row.each_with_index do |cell, x1|
                next if cell == ?.

                y2 = y - (rock_height - 1) + y1
                grid[y2][x + x1] = cell
              end
            end

            tower_height = [
              grid.length - y + (rock_height - 1),
              tower_height
            ].max

            break
          end
        end

        (y_offset + max_rock_height - 1 - (grid.length - tower_height)).times do
          grid.unshift(Array.new(chamber_width, " "))
        end
      end

      # puts grid.first(20).map(&:join).join("\n")

      tower_height
    end

    def solve_part1(input)
      solve(input)
    end

    def solve_part2(input)
      # FIXME: too many iterations. Must repeat until height has not changed for
      # a reasonable amount of rocks, then abort.
      # solve(input, 1_000_000_000_000)
    end
  end
end
