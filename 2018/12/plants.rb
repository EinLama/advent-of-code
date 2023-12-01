
#input = <<-EOF
#initial state: #..#.#..##......###...###
#
#...## => #
#..#.. => #
#.#... => #
#.#.#. => #
#.#.## => #
#.##.. => #
#.#### => #
##.#.# => #
##.### => #
###.#. => #
###.## => #
####.. => #
####.# => #
#####. => #
#EOF

input = File.read("input")

def parse_state(input)
  /\Ainitial state: ([.#]+)$/.match(input)[1]
end

def parse_rules(input)
  rules = input.scan(/^([.#]+) => ([.#]+)$/)
  Hash[rules]
end

def apply_rule(plants, rule_key, rule_sub=nil, start_index=0)
  index = plants.index(rule_key, start_index) 

  if index
    [index + rule_key.size / 2, rule_sub].concat(apply_rule(plants, rule_key, rule_sub, index + 1) || [])
  else
    nil
  end
end

def apply_replacements(plants, repl)
  plants = "." * plants.size

  repl.each do |index, sub|
    plants[index] = sub
  end

  plants
end

def next_generation(plants, rules)
  replacements = []

  rules.each do |from, to|
    #puts "validating rule: #{from} => #{to}"
    sub = apply_rule(plants, from, to)
    if sub
      sub.each_slice(2) do |s|
        replacements << s
      end
    end
  end

  apply_replacements(plants, replacements)
end

def plant_number(index, spacer_size)
  index - spacer_size
end

def all_plant_numbers(plants, spacer)
  plants.split("").map.with_index do |p, i|
    if p == "#"
      plant_number(i, SPACER.size)
    else
      0
    end
  end
end

SPACER = "." * 30

plants = SPACER + parse_state(input) + SPACER
rules = parse_rules(input)

puts " 0: #{plants}"
20.times do |t|
  plants = next_generation(plants, rules)
  puts "#{"%2d" % (t+1)}: #{plants}"
end

puts all_plant_numbers(plants, SPACER).inject(:+)

