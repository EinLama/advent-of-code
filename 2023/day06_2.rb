# frozen_string_literal: true

example = <<~EXMP
Time:      7  15   30
Distance:  9  40  200
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day06.txt"))
# input = example

lines = input.split("\n")
times = lines.first.scan(/\d+/).join("").to_i
distances = lines.last.scan(/\d+/).join("").to_i

# Race data is expressed in time => distance
race_records = [[times, distances]]


def break_record(time, distance)
  possible_wins = []
  (1...time).each do |pressed_button_for_t|
    travel_time = time - pressed_button_for_t
    travel_distance = travel_time * pressed_button_for_t

    possible_wins << pressed_button_for_t if travel_distance > distance
  end

  possible_wins
end

possible_win_strategies = 1
race_records.each do |time, distance|
  possible_win_strategies *= break_record(time, distance).count
end


pp possible_win_strategies
