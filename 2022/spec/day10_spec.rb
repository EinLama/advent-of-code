# frozen_string_literal: true

Day10 = Aoc2022::Day10
Cpu = Day10::Cpu

RSpec.describe Day10 do
  before :each do
    @cpu = Cpu.new
  end

  it "can parse input" do
    input = <<~INP
      noop
      addx 3
      addx -5
    INP

    parsed = Day10.parse_input(input)
    expect(parsed).to eq([["noop"], ["addx", 3], ["addx", -5]])
  end

  it "begins with zero executed cycles and X of 1" do
    expect(@cpu.cycle_count).to eq(0)
    expect(@cpu.register_x).to eq(1)
    expect(@cpu.after_cycle(0)).to eq({ x: 1 })
  end

  it "does nothing for one cycle if executing a noop" do
    @cpu.exec(["noop"])
    expect(@cpu.cycle_count).to eq(1)
    expect(@cpu.register_x).to eq(1)
  end

  it "increases the register X if executing addx and takes two cycles" do
    @cpu.exec(["addx", 13])
    expect(@cpu.cycle_count).to eq(2)
    expect(@cpu.register_x).to eq(14)
  end

  it "only increases the value of the register after the cycle has completed!" do
    @cpu.exec(["addx", 13])
    expect(@cpu.cycle_count).to eq(2)
    expect(@cpu.register_x).to eq(14)

    expect(@cpu.after_cycle(0)).to eq({ x: 1 })
    expect(@cpu.after_cycle(1)).to eq({ x: 1 })
    expect(@cpu.after_cycle(2)).to eq({ x: 14 })
  end

  it "solves the short example task" do
    @cpu.exec(["noop"])
    @cpu.exec(["addx", 3])
    @cpu.exec(["addx", -5])

    expect(@cpu.cycle_count).to eq(5)
    expect(@cpu.after_cycle(4)).to eq({ x: 4 })
    expect(@cpu.after_cycle(5)).to eq({ x: -1 })
  end
end
