# frozen_string_literal: true

module Aoc2022
  module Day16
    class ValveGraph
      attr_reader :minutes_remaining, :pressure_released, :open_valves, :current_pos

      def initialize(valves)
        @valves = valves
        @minutes_remaining = 30
        @pressure_released = []
        @open_valves = []
        @current_pos = valves.keys.first
      end

      def open?(v)
        @open_valves.include?(v)
      end

      def tunnels
        @valves[@current_pos][:tunnels]
      end

      def tunnel?(v)
        tunnels.include?(v)
      end

      def possible_paths
        tunnels.filter do |t|
          !open?(t)
        end
      end

      def open!
        raise "Already open: #{@current_pos}" if open?(@current_pos)

        take_minute
        @open_valves << @current_pos
        @pressure_released << [@minutes_remaining, @valves[@current_pos][:flow_rate]]
      end

      def travel_to(v)
        raise "Tunnel not found: #{v}" unless tunnel?(v)

        @current_pos = v
        take_minute
      end

      def open_best_valve!
        tunnel = next_best_tunnel

        return unless tunnel

        travel_to(tunnel)
        open! unless @valves[@current_pos][:flow_rate] == 0
      end

      def next_best_tunnel
        p = possible_paths.max_by do |name|
          @valves[name][:flow_rate]
        end

        raise "No best tunnel found at position: #{@current_pos}" unless p

        p
      end

      def take_minute
        @minutes_remaining -= 1
      end
    end

    module_function

    def parse(str)
      regex = /^Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (\w+.*)$/
      str.scan(regex).map do |v, fr, t|
        [v, fr.to_i, t.split(", ")]
      end
    end

    def build_valves(input)
      input.map do |v, fr, t|
        [v, { flow_rate: fr, tunnels: t }]
      end.to_h
    end

    def render_graph(graph)
      require "ruby-graphviz"

      g = GraphViz.new
      graph.valves.each do
        # TODO: build diagram here!
      end
    end

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      valves = build_valves(parse(input))

      vg = ValveGraph.new(valves)
      render_graph(vg)

      begin
        loop do
          vg.open_best_valve!
        end
      rescue StandardError
        p vg.open_valves
        p vg.pressure_released

        vg.pressure_released.inject(0) do |base, vals|
          base += vals.first * vals.last
        end
      end
    end

    def solve_part2(input); end
  end
end
