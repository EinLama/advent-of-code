def distance(s1, s2)
  return [] if s1.size != s2.size

  s1.split("").zip(s2.split("")).find_all { |c1, c2|
    c1 != c2
  }
end

def main()
  words = File.open("input02").map { |l| l.chomp }
  words = words.product(words)

  targets = words.find {|w1, w2| distance(w1, w2).count == 1 }

  targets[0].split("").zip(targets[1].split("")).map { |c1, c2|
    c1 == c2 ? c1 : ""
  }.join("")
end

puts main()