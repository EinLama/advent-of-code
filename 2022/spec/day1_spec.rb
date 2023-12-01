# frozen_string_literal: true

Elf = Aoc2022::Day1::Elf

RSpec.describe Aoc2022::Day1 do
  describe "an elf" do
    it "carries no calories to begin with" do
      elf = Elf.new

      expect(elf.calories).to eq(0)
    end

    it "can start with calories" do
      elf = Elf.new(calories: 30)

      expect(elf.calories).to eq(30)
    end

    it "can be instantiated from a string" do
      elves = Elf.from_str("")

      expect(elves).to be_a(Array)
      expect(elves.size).to eq(1)

      elf = elves.first
      expect(elf.calories).to eq(0)
    end

    it "can parse calories from lines" do
      elves = Elf.from_str("30")
      expect(elves.size).to eq(1)
      expect(elves.first.calories).to eq(30)

      elves = Elf.from_str("30\n20")
      expect(elves.size).to eq(1)
      expect(elves.first.calories).to eq(50)
    end

    it "creates a new elf per empty line" do
      elves = Elf.from_str("30\n10\n\n500")

      expect(elves.size).to eq(2)

      expect(elves[0].calories).to eq(40)
      expect(elves[1].calories).to eq(500)
    end
  end
end
