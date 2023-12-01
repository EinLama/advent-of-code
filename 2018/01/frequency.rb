def frequency()
  frequency = 0
  File.open("input01").each { |l| frequency += l.to_i }

  frequency
end

puts frequency()