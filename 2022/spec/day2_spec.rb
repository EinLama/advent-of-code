# frozen_string_literal: true

Rock = Aoc2022::Day2::Rock
Paper = Aoc2022::Day2::Paper
Scissors = Aoc2022::Day2::Scissors

RSpec.describe Aoc2022::Day2 do
  context "rock" do
    it "is equal to another rock" do
      expect(Rock.new).to eq(Rock.new)
    end

    it "is less than paper" do
      expect(Rock.new).to be <= Paper.new
    end

    it "is more than scissors" do
      expect(Rock.new).to be >= Scissors.new
    end
  end

  context "paper" do
    it "is equal to another paper" do
      expect(Paper.new).to eq(Paper.new)
    end

    it "is less than scissors" do
      expect(Paper.new).to be <= Scissors.new
    end

    it "is more than rock" do
      expect(Paper.new).to be >= Rock.new
    end
  end

  context "scissors" do
    it "is equal to another paper" do
      expect(Scissors.new).to eq(Scissors.new)
    end

    it "is less than rock" do
      expect(Scissors.new).to be <= Rock.new
    end

    it "is more than paper" do
      expect(Scissors.new).to be >= Paper.new
    end
  end

  context "playing" do
    it "returns 1 if we lose with a rock" do
      score = Aoc2022::Day2.play!(them: Paper.new, ours: Rock.new)

      expect(score).to eq(1)
    end

    it "returns 2 if we lose with paper" do
      score = Aoc2022::Day2.play!(them: Scissors.new, ours: Paper.new)

      expect(score).to eq(2)
    end

    it "returns 3 if we lose with scissors" do
      score = Aoc2022::Day2.play!(them: Rock.new, ours: Scissors.new)

      expect(score).to eq(3)
    end

    it "returns 7 if we win with a rock" do
      score = Aoc2022::Day2.play!(them: Scissors.new, ours: Rock.new)

      expect(score).to eq(7)
    end

    it "returns 8 if we win with paper" do
      score = Aoc2022::Day2.play!(them: Rock.new, ours: Paper.new)

      expect(score).to eq(8)
    end

    it "returns 9 if we win with scissors" do
      score = Aoc2022::Day2.play!(them: Paper.new, ours: Scissors.new)

      expect(score).to eq(9)
    end

    it "returns 4, 5, 6 for a draw with the specific choice" do
      plays = [
        { choice: Rock.new, expected_score: 4 },
        { choice: Paper.new, expected_score: 5 },
        { choice: Scissors.new, expected_score: 6 }
      ]

      plays.each do |p|
        score = Aoc2022::Day2.play!(them: p[:choice], ours: p[:choice])
        expect(score).to eq(p[:expected_score])
      end
    end
  end

  context "parsing from_line" do
    it "parses A Y" do
      them, ours = Aoc2022::Day2.from_line("A Y")

      expect(them).to eq(Rock.new)
      expect(ours).to eq(Paper.new)
    end

    it "parses B X" do
      them, ours = Aoc2022::Day2.from_line("B X")

      expect(them).to eq(Paper.new)
      expect(ours).to eq(Rock.new)
    end

    it "parses C Z" do
      them, ours = Aoc2022::Day2.from_line("C Z")

      expect(them).to eq(Scissors.new)
      expect(ours).to eq(Scissors.new)
    end

    it "parses multiple lines" do
      lines = Aoc2022::Day2.from_lines("A X\nB Z")

      expect(lines.size).to eq(2)

      expect(lines[0][0]).to eq(Rock.new)
      expect(lines[0][1]).to eq(Rock.new)

      expect(lines[1][0]).to eq(Paper.new)
      expect(lines[1][1]).to eq(Scissors.new)
    end
  end

  context "part 2" do
    context "guessing response" do
      it "makes you lose when it encounters X" do
        them, ours = Aoc2022::Day2.from_line("A X", guess_response: true)
        expect(them).to eq(Rock.new)
        expect(ours).to eq(Scissors.new)

        them, ours = Aoc2022::Day2.from_line("B X", guess_response: true)
        expect(them).to eq(Paper.new)
        expect(ours).to eq(Rock.new)

        them, ours = Aoc2022::Day2.from_line("C X", guess_response: true)
        expect(them).to eq(Scissors.new)
        expect(ours).to eq(Paper.new)
      end

      it "makes you draw when it encounters Y" do
        them, ours = Aoc2022::Day2.from_line("A Y", guess_response: true)
        expect(them).to eq(Rock.new)
        expect(ours).to eq(Rock.new)

        them, ours = Aoc2022::Day2.from_line("B Y", guess_response: true)
        expect(them).to eq(Paper.new)
        expect(ours).to eq(Paper.new)

        them, ours = Aoc2022::Day2.from_line("C Y", guess_response: true)
        expect(them).to eq(Scissors.new)
        expect(ours).to eq(Scissors.new)
      end

      it "makes you win when it encounters Z" do
        them, ours = Aoc2022::Day2.from_line("A Z", guess_response: true)
        expect(them).to eq(Rock.new)
        expect(ours).to eq(Paper.new)

        them, ours = Aoc2022::Day2.from_line("B Z", guess_response: true)
        expect(them).to eq(Paper.new)
        expect(ours).to eq(Scissors.new)

        them, ours = Aoc2022::Day2.from_line("C Z", guess_response: true)
        expect(them).to eq(Scissors.new)
        expect(ours).to eq(Rock.new)
      end
    end
  end
end
