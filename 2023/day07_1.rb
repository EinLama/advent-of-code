# frozen_string_literal: true

example = <<~EXMP
  32T3K 765
  T55J5 684
  KK677 28
  KTJJT 220
  QQQJA 483
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day07.txt"))
# input = example

def parse(str)
  str.split("\n").map do |line|
    hand, bid = line.split
    [hand, bid.to_i]
  end
end

HAND_SCORE = {
  five_of_a_kind: 700,
  four_of_a_kind: 600,
  full_house: 500,
  three_of_a_kind: 400,
  two_pair: 300,
  one_pair: 200,
  high_card: 100
}.freeze

CARD_STRENGTH = %w[A K Q J T 9 8 7 6 5 4 3 2].reverse.map.with_index { [_1, _2] }.to_h

class Hand
  include Comparable

  attr_reader :cards, :bid

  def initialize(cards = [], bid = 0)
    @cards = cards
    @bid = bid
  end

  def label
    @label ||= analyze_hand(@cards)
  end

  def score
    HAND_SCORE[label]
  end

  def <=>(other)
    if other.score == score
      cards.each_with_index do |c, i|
        comp = CARD_STRENGTH[c] <=> CARD_STRENGTH[other.cards[i]]
        # puts "comparing #{c} with #{other.cards[i]}: #{comp}"
        return comp if comp != 0
      end
      0
    else
      score <=> other.score
    end
  end

  private def analyze_hand(hand)
    c = hand.tally

    case c.values.sort.reverse
    in [5]
      :five_of_a_kind
    in [4, 1]
      :four_of_a_kind
    in [3, 2]
      :full_house
    in [3, *]
      :three_of_a_kind
    in [2, 2, 1]
      :two_pair
    in [2, *]
      :one_pair
    else
      :high_card
    end
  end

end

cards_bids = parse(input)

hands = cards_bids.map do |hand, bid|
  Hand.new hand.split(""), bid
end

# h1 = Hand.new("KK677".split(""), 100)
# h2 = Hand.new("KTJJT".split(""), 300)
#
# pp h1 <=> h2
# exit

sorted = hands.sort

rank_multipliers = sorted.map.with_index do |h, idx|
  {
    score: h.score,
    bid: h.bid,
    hand: h.cards.join(""),
    total_score: h.bid * (idx + 1),
    rank: idx + 1
  }
end

# pp rank_multipliers
pp rank_multipliers.sum { _1[:total_score] }



