# frozen_string_literal: true

example = <<~EXMP
  Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day04.txt"))
# input = example


class Card
  def initialize(line)
    @id = line.scan(/^Card (\d+):/)
    number_parts = line.split(":").last
    @winning_numbers = number_parts.split("|").first.split(" ").map(&:to_i)
    @own_numbers = number_parts.split("|").last.split(" ").map(&:to_i)
  end

  def score
    return @score if @score

    matches = @winning_numbers.select { @own_numbers.include? _1 }.count
    @score = (1..matches).inject(0) { |score, match| match == 1 ? 1 : score * 2 }
  end
end


cards = input.split("\n").map do |line|
  Card.new line
end

pp cards.map(&:score).sum
