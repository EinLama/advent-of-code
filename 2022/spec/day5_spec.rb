# frozen_string_literal: true

Day5 = Aoc2022::Day5
Instruction = Day5::Instruction

RSpec.describe Aoc2022::Day5 do
  context "crates" do
    it "parses crates" do
      crates = Day5.parse_crates("    [D]    \n[N] [C]    \n[Z] [M] [P]\n 1   2   3 ")

      expect(crates).to eq([%w[Z N], %w[M C D], ["P"]])
    end
  end

  context "instructions" do
    it "parses one instruction" do
      inst = Day5.parse_instruction("move 1 from 2 to 1")

      expect(inst).to eq(Instruction.new(2, 1, 1))
    end

    it "parses multiple instructions" do
      inst = Day5.parse_instructions("move 1 from 2 to 1\nmove 1 from 2 to 3\nmove 4 from 10 to 8")

      expect(inst.size).to eq(3)
      expect(inst[0]).to eq(Instruction.new(2, 1, 1))
      expect(inst[1]).to eq(Instruction.new(2, 3, 1))
      expect(inst[2]).to eq(Instruction.new(10, 8, 4))
    end
  end

  context "crate stacking" do
    it "can apply an instruction on crates" do
      crates = [%w[Z N], %w[M C D], ["P"]]
      instruction = Instruction.new(2, 1, 1)

      new_stack = Day5.apply_instruction!(crates, instruction)
      expect(new_stack).to eq([%w[Z N D], %w[M C], ["P"]])

      instruction = Instruction.new(3, 2, 1)
      new_stack = Day5.apply_instruction!(crates, instruction)
      expect(new_stack).to eq([%w[Z N D], %w[M C P], []])
    end

    it "can move multiple crates one after another" do
      crates = [%w[Z N], %w[M C D], ["P"]]
      instruction = Instruction.new(2, 3, 2)

      new_stack = Day5.apply_instruction!(crates, instruction)
      expect(new_stack).to eq([%w[Z N], %w[M], %w[P D C]])
    end

    it "can move multiple crates at once" do
      crates = [%w[Z N], %w[M C D], ["P"]]
      instruction = Instruction.new(2, 3, 2)

      new_stack = Day5.apply_instruction!(crates, instruction, all_at_once: true)
      expect(new_stack).to eq([%w[Z N], %w[M], %w[P C D]])
    end
  end

  context "top crates" do
    it "can show all top row crates as result string" do
      crates = [%w[Z N], %w[M C D], ["P"]]
      top = Day5.top_crates(crates)

      expect(top).to eq("NDP")
    end
  end
end
