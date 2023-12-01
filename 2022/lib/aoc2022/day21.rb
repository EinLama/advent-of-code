# frozen_string_literal: true

module Aoc2022
  module Day21

    module_function

    def parse_result(op)
      case op
      when /\+/
        op.split("+").map(&:strip) << :+
      when /\*/
        op.split("*").map(&:strip) << :*
      when /-/
        op.split("-").map(&:strip) << :-
      when %r{/}
        op.split("/").map(&:strip) << :/
      else
        op.to_i
      end
    end

    def set_value_in_hash(data, key)
      val = data[key]
      return if val.is_a?(Integer)

      case val
      in [a, b, operation]
        set_value_in_hash(data, a)
        set_value_in_hash(data, b)

        data[key] = data[a].send(operation, data[b])
      end
    end

    def build_data(entries)
      data = {}
      entries.each do |monkey, op|
        data[monkey] = parse_result(op)
      end

      data
    end

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      parsed = input.scan(/^(\w+): (.*)$/)
      data = build_data(parsed)

      set_value_in_hash(data, "root")

      data["root"]
    end

    def solve_part2(input) end
  end
end
