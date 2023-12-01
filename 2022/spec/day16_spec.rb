# frozen_string_literal: true

Day16 = Aoc2022::Day16
ValveGraph = Day16::ValveGraph

RSpec.describe Day16 do
  input = <<~WRLD
    Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
    Valve BB has flow rate=13; tunnels lead to valves CC, AA
  WRLD

  valves = [
    ["AA", 0, %w[DD II BB]],
    ["BB", 13, %w[CC AA]]
  ]
  valves_as_hash = {
    "AA" => { flow_rate: 0, tunnels: %w[DD II BB] },
    "BB" => { flow_rate: 13, tunnels: %w[CC AA] }
  }

  context "parsing" do
    it "parses input" do
      inp = Day16.parse(input)
      expect(inp).to eq(valves)
    end
  end

  context "valves" do
    it "builds valves from parsed input" do
      valves = Day16.build_valves(valves)

      expect(valves).to eq(valves_as_hash)
    end
  end

  context "valve graph" do
    before :each do
      @vg = ValveGraph.new(valves_as_hash)
    end

    it "begins with 30 minutes remaining and no opened valves" do
      expect(@vg.current_pos).to eq("AA")
      expect(@vg.minutes_remaining).to eq(30)
      expect(@vg.open_valves).to eq([])
      expect(@vg.pressure_released).to eq([])
    end

    it "can open a valve by taking a minute" do
      @vg.open!

      expect(@vg.minutes_remaining).to eq(29)
      expect(@vg.open_valves).to eq(["AA"])
      expect(@vg.pressure_released).to eq([[29, 0]])
    end

    it "cannot open a valve a second time" do
      @vg.open!

      expect { @vg.open! }.to raise_error
    end

    it "can take a minute to travel to another valve if they are connected" do
      @vg.travel_to("BB")

      expect(@vg.current_pos).to eq("BB")
      expect(@vg.minutes_remaining).to eq(29)
      expect(@vg.open_valves).to eq([])

      @vg.open!
      expect(@vg.minutes_remaining).to eq(28)
      expect(@vg.open_valves).to eq(["BB"])
      expect(@vg.pressure_released).to eq([[28, 13]])
    end

    it "can't travel if two valves aren't connected" do
      expect { @vg.travel_to("UU") }.to raise_error
    end

    it "can list all paths it hasn't travelled yet from the current node" do
      expect(@vg.possible_paths).to eq(%w[DD II BB])
      @vg.open!
      @vg.travel_to("BB")

      expect(@vg.possible_paths).to eq(%w[CC])
      @vg.open!

      @vg.travel_to("AA")
      expect(@vg.possible_paths).to eq(%w[DD II])
    end

    context "pathfinding" do
      before :each do
        @bigger_world = { "AA" => { flow_rate: 0, tunnels: %w[DD II BB] },
                          "BB" => { flow_rate: 13, tunnels: %w[CC AA] },
                          "DD" => { flow_rate: 20, tunnels: %w[CC AA] },
                          "II" => { flow_rate: 0, tunnels: %w[AA] },
                          "CC" => { flow_rate: 2, tunnels: %w["BB DD"] } }

        #
        #   A ---- B ---- C
        #   |             |
        #   |----- D ----/
        #   |
        #   ------ I
        #

        @vg = ValveGraph.new(@bigger_world)
      end

      it "picks the tunnel with the best flow rate" do
        expect(@vg.next_best_tunnel).to eq("DD")
      end

      it "raises and error when there are no routes anymore" do
        @vg.open!
        @vg.travel_to("II")
        @vg.open!

        expect { @vg.next_best_tunnel }.to raise_error
      end

      it "can move to the best tunnel and open it" do
        @vg.open_best_valve!

        expect(@vg.current_pos).to eq("DD")
        expect(@vg.open_valves).to eq(["DD"])
        expect(@vg.pressure_released).to eq([[28, 20]])
      end

      it "will not open a tunnel with zero pressure when doing so" do
        @vg.travel_to("II")
        @vg.open_best_valve!

        expect(@vg.current_pos).to eq("AA")
        expect(@vg.open_valves).to be_empty
      end
    end
  end
end
