require_relative "helpers"

class AdvancedOpCodeMachine
  attr_accessor :opcodes
  attr_reader :current_address, :result

  def initialize(opcodes=[])
    if opcodes.is_a?(String)
      @opcodes = parse(opcodes)
    else
      @opcodes = opcodes
    end

    @current_address = 0
    @result = 0
  end

  def find_opcode
    opcode = @opcodes[@current_address]

    raise "Unkown Opcode #{opcode} at pos: #{@current_address}" unless [1, 2, 99].include?(opcode)
    opcode
  end

  def find_parameters
    [@opcodes[read_rel(1)], @opcodes[read_rel(2)]]
  end

  def find_target_index
    read_rel(3)
  end

  def handle_instruction!
    opcode = find_opcode()

    return :halt if opcode == 99

    noun, verb = find_parameters()
    instruction = {
      1 => :+,
      2 => :*,
    }[opcode]

    @result = noun.send(instruction, verb)

    @opcodes[find_target_index()] = @result

    @opcodes
  end

  def move!
    @current_address += 4
  end

  def run!
    while handle_instruction! != :halt
      move!
    end

    @result
  end

  private

  def read_rel(pos)
    @opcodes[@current_address + pos]
  end

  def parse(string_codes)
    string_codes.split(",").map(&:to_i)
  end
end


def solution
  (1..99).each do |i|
    (1..99).each do |j|
      opcodes = File.read(filepath("day2.txt"))
      machine = OpCodeMachine.new(opcodes)

      machine.opcodes[1] = i
      machine.opcodes[2] = j

      machine.run!

      result = machine.opcodes
      puts "ran: #{result.first}"

      if result.first == 19690720
        puts "noun: #{result[1]}, verb: #{result[2]}, result: #{100 * result[1] + result[2]}"
        return
      end
    end
  end
end

if __FILE__ == $0
  solution()
end

