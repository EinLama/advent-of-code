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
  h = Hash.new { |h, k| h[k] = [] }

  r, = str.split("\n\n")
  r.split("\n").each do |rule|
    key, value = rule.split("|").map(&:to_i)
    h[key] << value
  end

  h
end

def extract_updates(str)
  _, u = str.split("\n\n")
  u.split("\n").map do |update|
    update.split(",").map(&:to_i)
  end
end

def valid_update?(update, rules)
  done = []

  update.each do |u|
    if done.empty?
      done << u
      next
    end

    rules[u].each do |r|
      if done.any?(r)
        # puts "rule #{u}|#{r} violated"
        return false
      end
    end

    done << u
  end

  true
end

def find_middle(update)
  update[update.length / 2]
end

rules = extract_rules(input)
updates = extract_updates(input)

# pp rules
# pp updates

valid_updates = updates.find_all { |u| valid_update?(u, rules) }
pp valid_updates.map { |u| find_middle(u) }.inject(:+)