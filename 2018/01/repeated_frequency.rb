require "set"

def repeated()
  frequency = 0
  results = Set.new
  all_frequencies = File.open("input01").map { |f| f.to_i }

  all_frequencies.cycle do |f|
    frequency += f

    return frequency if results.include?(frequency)
    results << frequency
  end

  nil
end

puts repeated()