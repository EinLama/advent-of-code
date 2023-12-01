# frozen_string_literal: true

Day4 = Aoc2022::Day4

RSpec.describe Aoc2022::Day4 do
  context "pairs" do
    it "extracts pair ranges" do
      range1, range2 = Day4.pairs("2-4,6-8")

      expect(range1).to eq(2..4)
      expect(range2).to eq(6..8)
    end

    it "returns true on complete overlap" do
      expect(Day4.overlap?(3..6, 4..5)).to be true
      expect(Day4.overlap?(1..2, 1..8)).to be true
      expect(Day4.overlap?(2..8, 3..7)).to be true
    end

    it "returns false on only partial or no overlap" do
      expect(Day4.overlap?(2..4, 6..8)).to be false
      expect(Day4.overlap?(2..3, 4..5)).to be false
      expect(Day4.overlap?(2..6, 4..8)).to be false
    end

    it "returns true on partial overap" do
      expect(Day4.partial_overlap?(2..6, 4..8)).to be true
      expect(Day4.partial_overlap?(2..4, 6..8)).to be false
    end
  end
end
