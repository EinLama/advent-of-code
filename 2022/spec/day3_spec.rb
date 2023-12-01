# frozen_string_literal: true

Rucksack = Aoc2022::Day3::Rucksack
Day3 = Aoc2022::Day3

RSpec.describe Aoc2022::Day3 do
  context "rucksack" do
    it "has two compartments" do
      rucksack = Rucksack.new("foba")
      compartments = rucksack.compartments

      expect(compartments.size).to eq(2)
      expect(compartments[0]).to eq("fo")
      expect(compartments[1]).to eq("ba")
    end

    it "finds duplicates from both compartments" do
      dup = Rucksack.new("vJrwpWtwJgWrhcsFMMfFFhFp").find_dups
      expect(dup).to eq("p")

      dup = Rucksack.new("jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL").find_dups
      expect(dup).to eq("L")
    end
  end

  context "priorities" do
    it "gives `a through z` a priority of 1-26" do
      expect(Day3.priority("a")).to eq(1)
      expect(Day3.priority("c")).to eq(3)
      expect(Day3.priority("z")).to eq(26)
    end

    it "gives `A through Z` a priority of 27-52" do
      expect(Day3.priority("A")).to eq(27)
      expect(Day3.priority("C")).to eq(29)
      expect(Day3.priority("Z")).to eq(52)
    end
  end

  context "group_badge" do
    it "finds the char that is in all three lines" do
      badge = Day3.group_badge(%w[abc bzz yub])
      expect(badge).to eq("b")
    end
  end
end
