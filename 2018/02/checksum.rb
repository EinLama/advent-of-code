def checksum()
  twos = 0
  threes = 0

  File.open("input02").each do |l|
    counts = l.split("").inject(Hash.new(0)) { |h,c| h[c] += 1; h }
    twos += 1 if counts.any? {|k,v| v == 2}
    threes += 1 if counts.any? {|k,v| v == 3}
  end

  twos * threes
end

puts checksum()