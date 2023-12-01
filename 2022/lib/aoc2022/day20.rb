# frozen_string_literal: true

module Aoc2022
  module Day20

    module_function

    def mix(lst, entry)
      # No point in moving zero:
      return if entry.is_a?(Integer)

      val, _id = entry
      position = lst.find_index(entry)

      move_to = (position + val) % (lst.size - 1)
      move_to -= 1 if move_to.zero? # wrap around

      lst.delete_at(position)
      lst.insert(move_to, val)
    end

    def find_1k2k3k(lst)
      [
        lst[(lst.index(0) + 1_000) % lst.length],
        lst[(lst.index(0) + 2_000) % lst.length],
        lst[(lst.index(0) + 3_000) % lst.length]
      ].sum
    end

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      lst = []
      idx = 0
      input.lines do |line|
        lst << (line.to_i.zero? ? 0 : [line.to_i, idx])
        idx += 1
      end

      new_lst = lst.dup
      lst.each do |entry|
        mix(new_lst, entry)
      end

      find_1k2k3k(new_lst)
    end

    def solve_part2(input) end
  end
end
