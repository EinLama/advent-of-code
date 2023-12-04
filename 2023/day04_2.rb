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
  attr_reader :id

  def initialize(line)
    @id = line.scan(/^Card\s+(\d+):/).flatten.first.to_i
    number_parts = line.split(":").last
    @winning_numbers = number_parts.split("|").first.split(" ").map(&:to_i)
    @own_numbers = number_parts.split("|").last.split(" ").map(&:to_i)
  end

  def internal_matches
    @winning_numbers.select { @own_numbers.include? _1 }.count
  end

  def to_s
    @id
  end

  def inspect
    "<Card #{@id}>"
  end
end

all_cards = input.split("\n").map do |line|
  c = Card.new line
  [c.id, [c]]
end.to_h

all_cards.values.each do |cards|
  cards.each do |c|
    matches = c.internal_matches
    cards_to_copy = ((c.id + 1)..(c.id + matches)).to_a
    cards_to_copy.each do |copy_card_id|
      card_to_copy = all_cards[copy_card_id].first
      # would have been better not to copy objects around here, but instead just store a hash of id => count
      all_cards[copy_card_id] << card_to_copy
    end
  end
end

puts all_cards.values.map(&:count).sum
