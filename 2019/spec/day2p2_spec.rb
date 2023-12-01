require "rspec"
require_relative "../day2p2"

describe "day2" do
  context "initialize machine" do
    it "converts a string of integers to a list of integers" do
      machine = AdvancedOpCodeMachine.new("0,1,2,3,0")
      expect(machine.opcodes).to eq([0, 1, 2, 3, 0])
    end

    it "trims newlines and whitespace" do
      machine = AdvancedOpCodeMachine.new("0     ,  1,2,3    ,0\n")
      expect(machine.opcodes).to eq([0, 1, 2, 3, 0])
    end

    it "starts with a position of 0" do
      machine = AdvancedOpCodeMachine.new()
      expect(machine.current_address).to eq(0)
      expect(machine.result).to eq(0)
    end
  end

  context "opcodes" do
    it "finds the opcode" do
      machine = AdvancedOpCodeMachine.new([1,0,0,3,99])
      expect(machine.find_opcode()).to eq(1)
    end

    it "allows 1, 2 and 99 as opcodes" do
      [1, 2, 99].each do |opcode|
        machine = AdvancedOpCodeMachine.new([opcode])
        expect(machine.find_opcode()).to eq(opcode)
      end
    end

    it "will throw an error if an unknown opcode is found" do
      (3..98).each do |opcode|
        machine = AdvancedOpCodeMachine.new([opcode])

        expect { machine.find_opcode() }.to raise_error("Unkown Opcode #{opcode} at pos: 0")
      end
    end

    it "finds the operands for an instruction" do
      machine = AdvancedOpCodeMachine.new([1,0,0,3,99])
      expect(machine.find_parameters()).to eq([1, 1])

      machine = AdvancedOpCodeMachine.new([1,2,0,3,99])
      expect(machine.find_parameters()).to eq([0, 1])
    end

    it "finds the target for an instruction" do
      machine = AdvancedOpCodeMachine.new([1,0,0,3,99])
      expect(machine.find_target_index()).to eq(3)

      machine = AdvancedOpCodeMachine.new([1,0,0,8,99])
      expect(machine.find_target_index()).to eq(8)
    end

    it "can move" do
      machine = AdvancedOpCodeMachine.new([1,0,0,3,99])
      expect(machine.current_address).to eq(0)

      machine.move!
      expect(machine.current_address).to eq(4)
      expect(machine.find_opcode()).to eq(99)
    end

    it "adds" do
      machine = AdvancedOpCodeMachine.new([1,0,0,3,99])
      expect(machine.handle_instruction!()).to eq([1, 0, 0, 2, 99])
      expect(machine.result).to eq(2)
    end

    it "multiplies" do
      machine = AdvancedOpCodeMachine.new([2,0,3,3,99])
      expect(machine.handle_instruction!()).to eq([2, 0, 3, 6, 99])
      expect(machine.result).to eq(6)
    end

    it "halts" do
      original_opcodes = [99, 1, 0, 0, 1, 0, 2, 0, 5, 0]
      machine = AdvancedOpCodeMachine.new(original_opcodes)

      expect(machine.handle_instruction!()).to eq(:halt)

      # opcodes are not modified when the instruction says halt
      expect(machine.opcodes).to eq(original_opcodes)
    end

    it "runs until it finds a halt instruction and yields the result" do
      programs = [
        { input: [1,0,0,0,99], expected_result: 2, expected_state: [2,0,0,0,99] },
        { input: [2,3,0,3,99], expected_result: 6, expected_state: [2,3,0,6,99] },
        { input: [2,4,4,5,99,0], expected_result: 9801, expected_state: [2,4,4,5,99,9801] },
        { input: [1,1,1,4,99,5,6,0,99], expected_result: 30, expected_state: [30,1,1,4,2,5,6,0,99] },
      ]

      programs.each do |program|
        machine = AdvancedOpCodeMachine.new(program[:input])
        expect(machine.run!).to eq(program[:expected_result])
        expect(machine.opcodes).to eq(program[:expected_state])
      end
    end
  end
end


