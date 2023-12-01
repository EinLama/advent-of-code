 #(97..122).include? a.ord #lowercase

def polarity?(a, b=nil)
  return false unless b # guard for first call

  (a.ord - b.ord).abs == 32 # same letter, opposing case
end

def process_char(c, current_str)
  if polarity?(c, current_str.last)
    # polarity found, removing
    return current_str.take(current_str.size - 1)
  else
    return current_str + [c]
  end
end

def iterate(input)
  current_str = []
  input.each do |c|
    current_str = process_char(c, current_str)
  end
  current_str
end

def polymere()
  input = File.read("input05").chomp.split("")

  current_str = iterate(input)

  current_str.size
end

puts polymere()