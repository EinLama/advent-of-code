# frozen_string_literal: true

example = <<-EXMP
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
EXMP

def extract_num(str, pattern)
  str.scan(pattern).flatten.first.to_i
end

def parse_line(line)
  game_id = extract_num(line, /Game (\d+):/)

  raw_games = line.split(":").last.split(";")
  games = raw_games.map do |g|
    greens = extract_num(g, /(\d+) green/)
    reds = extract_num(g, /(\d+) red/)
    blues = extract_num(g, /(\d+) blue/)

    {r: reds, g: greens, b: blues}
  end

  [game_id, games]
end

def find_min_cube_count(game)
  game.reduce({r: 0, g: 0, b: 0}) do |max_vals, h|
    {
      r: [max_vals[:r], h[:r]].max,
      g: [max_vals[:g], h[:g]].max,
      b: [max_vals[:b], h[:b]].max,
    }
  end
end

def power_of_game(game)
  game.values.inject(:*)
end

input = File.read(File.join(File.dirname(__FILE__), "day02.txt"))
# input = example

games = input.split("\n").map do |line|
  parse_line(line).last
end

game_powers = games.map do |game|
  power_of_game find_min_cube_count(game)
end

puts game_powers.sum




