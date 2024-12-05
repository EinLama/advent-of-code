# frozen_string_literal: true

example = <<~EXMP
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day05.txt"))
# input = example

def extract_rules(str)
  str.each_line.with_object(Hash.new { |h, k| h[k] = [] }) do |line, h|
    key, value = line.split("|").map(&:to_i)
    h[key] << value
  end
end

def extract_updates(str)
  _, u = str.split("\n\n")
  u.split("\n").map do |update|
    update.split(",").map(&:to_i)
  end
end

def valid_update?(update, rules)
  done = Set.new

  update.each do |u|
    return false if rules[u].any? { |r| done.include?(r) }

    done.add(u)
  end

  true
end

def find_middle(update)
  update[update.length / 2]
end

def reorder(update, rules)
  update.sort do |a, b|
    if rules[a]&.include?(b)
      -1
    elsif rules[b]&.include?(a)
      1
    else
      0
    end
  end
end

rules = extract_rules(input)
updates = extract_updates(input)

# pp rules
# pp updates

invalid_updates = updates.reject { |u| valid_update?(u, rules) }
reordered = invalid_updates.map { |u| reorder(u, rules) }
pp reordered.map { |u| find_middle(u) }.inject(:+)
