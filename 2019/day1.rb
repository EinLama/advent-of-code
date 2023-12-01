require_relative "helpers"

def fuel(mass)
  mass / 3 - 2
end

def fuels_for_all(masses=[])
  masses.map { |m| fuel(m) }.inject(:+)
end

def read_masses(lines=[])
  lines.map { |l| l.strip.to_i }.reject(&:zero?)
end

def solution
  masses = read_masses(readlines("day1.txt"))
  fuels_for_all(masses)
end

if __FILE__ == $0
  puts solution()
end
