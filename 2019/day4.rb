
def doubles(str)
  doubles = []

  prev_c = nil
  str.each_char do |c|
    doubles << c if prev_c && c == prev_c
    prev_c = c
  end

  doubles
end

def count_multiples(chars)
  # ensure array:
  chars = chars.split("") if chars.is_a?(String)

  mults = Hash.new(0)
  chars.each do |c|
    mults[c] +=1
  end

  mults
end

def valid_multiples?(chars)
  multiples = count_multiples(chars)

  prev_d, prev_c = [nil, nil]
  multiples.each do |digit, count|
    if prev_d
      #puts "digit: #{digit}, count: #{count}, pev_c: #{prev_c}"
      if prev_d.to_i > digit.to_i || count >= 2 && count > prev_c
        return false
      end
    end

    prev_d = digit
    prev_c = count
  end

  true
end

def valid_password?(password)
  return false unless password.length == 6
  return false if doubles(password).empty?

  # Ensure order is ascending:
  return password.split("") == password.split("").sort
end

def valid_password_uniq_doubles?(password)
  return false unless password.length == 6

  double_digits = doubles(password)
  return false if double_digits.empty?

  # Ensure order is ascending:
  return password.split("") == password.split("").sort
end

def range()
  158126..624574
end

def solution()
  range().count { |password|
    valid_password?(password.to_s)
  }
end

def solution_part2()
  range().count { |password|
    valid_password?(password.to_s) && valid_multiples?(password.to_s)
  }
end

if __FILE__ == $0
  puts solution_part2()
end
