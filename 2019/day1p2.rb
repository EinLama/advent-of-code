require_relative "day1"

def fuel_cumulative(mass)
  total_fuel = 0
  fuel_for_this_mass = 0

  loop do
    fuel_for_this_mass = fuel(mass)
    total_fuel += fuel_for_this_mass if fuel_for_this_mass > 0

    return total_fuel if fuel_for_this_mass / 3 <= 0

    mass = fuel_for_this_mass
  end
end

def fuels_for_all(masses=[])
  masses.map { |m| fuel_cumulative(m) }.inject(:+)
end

def solution
  masses = read_masses(readlines("day1.txt"))
  fuels_for_all(masses)
end

if __FILE__ == $0
  puts solution()
end
