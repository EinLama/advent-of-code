# frozen_string_literal: true

Day6 = Aoc2022::Day6

RSpec.describe Aoc2022::Day6 do
  context "marker positions" do
    it "should report 7" do
      marker = Day6.find_marker("mjqjpqmgbljsphdztnvjfqwrcgsmlb")
      expect(marker).to eq(7)
    end

    it "should report 5" do
      marker = Day6.find_marker("bvwbjplbgvbhsrlpgdmjqwftvncz")
      expect(marker).to eq(5)
    end

    it "should report 6" do
      marker = Day6.find_marker("nppdvjthqldpwncqszvftbrmjlhg")
      expect(marker).to eq(6)
    end

    it "should report 10" do
      marker = Day6.find_marker("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")
      expect(marker).to eq(10)
    end

    it "should report 11" do
      marker = Day6.find_marker("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")
      expect(marker).to eq(11)
    end
  end
end
