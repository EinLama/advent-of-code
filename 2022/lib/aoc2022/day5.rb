# frozen_string_literal: true

module Aoc2022
  module Day5
    Instruction = Struct.new(:from, :to, :amount)

    module_function

    def parse_crates(str)
      lines = str.split("\n").filter_map do |line|
        if line =~ / 1 /
          nil
        else
          group_matches = line.scan(/\s{4}|([A-Z])/)
          group_matches.map(&:compact)
        end
      end

      crates = []
      lines.reverse.each do |l|
        l.each_with_index do |c, i|
          crates[i] ||= []

          crates[i] << c[0]
        end
      end
      crates.map(&:compact)
    end

    def parse_instruction(instr)
      found = instr.match(/move (\d+) from (\d+) to (\d+)/).captures.map(&:to_i)
      Instruction.new(found[1], found[2], found[0])
    end

    def parse_instructions(instr)
      instr.split("\n").map { |i| parse_instruction(i) }
    end

    def parse_input(str)
      s = str.split("\n")
      i = s.index("")

      crates = parse_crates(s[0..(i - 1)].join("\n"))
      instr = parse_instructions(s[(i + 1)..-1].join("\n"))

      [crates, instr]
    end

    def apply_instruction!(crates, instruction, all_at_once: false)
      if all_at_once
        c = crates[instruction.from - 1].pop(instruction.amount)
        crates[instruction.to - 1].push(*c)
      else
        instruction.amount.times do
          c = crates[instruction.from - 1].pop
          crates[instruction.to - 1].push(c)
        end
      end

      crates
    end

    def top_crates(crates)
      crates.map(&:last).join("")
    end

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      crates, instr = parse_input(input)

      instr.each do |i|
        crates = apply_instruction!(crates, i)
      end

      top_crates(crates)
    end

    def solve_part2(input)
      crates, instr = parse_input(input)

      instr.each do |i|
        crates = apply_instruction!(crates, i, all_at_once: true)
      end

      top_crates(crates)
    end
  end
end
