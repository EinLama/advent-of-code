require_relative "helpers"

class OpCodeMachine
  attr_accessor :opcodes
  attr_reader :current_position, :result

  def initialize(opcodes=[])
    if opcodes.is_a?(String)
      @opcodes = parse(opcodes)
    else
      @opcodes = opcodes
    end

    @current_position = 0
    @result = 0
  end

  def find_opcode
    opcode = @opcodes[@current_position]

    raise "Unkown Opcode #{opcode} at pos: #{@current_position}" unless [1, 2, 99].include?(opcode)
    opcode
  end

  def find_operands
    [@opcodes[read_rel(1)], @opcodes[read_rel(2)]]
  end

  def find_target_index
    read_rel(3)
  end

  def handle_instruction!
    instruction = find_opcode()

    return :halt if instruction == 99

    operands = find_operands()
    operation = {
      1 => :+,
      2 => :*,
    }[instruction]

    @result = operands[0].send(operation, operands[1])
    @opcodes[find_target_index()] = @result

    @opcodes
  end

  def move!
    @current_position += 4
  end

  def run!
    while handle_instruction! != :halt
      move!
    end

    @result
  end

  private

  def read_rel(pos)
    @opcodes[@current_position + pos]
  end

  def parse(string_codes)
    string_codes.split(",").map(&:to_i)
  end
end


def solution_part1
  opcodes = File.read(filepath("day2.txt"))
  machine = OpCodeMachine.new(opcodes)

  machine.opcodes[1] = 12
  machine.opcodes[2] = 2

  machine.run!
end

if __FILE__ == $0
  puts solution()
end
