# frozen_string_literal: true

Day9 = Aoc2022::Day9
Rope = Day9::Rope

RSpec.describe Day9 do
  context "directions" do
    it "parses input" do
      directions = <<~DIR
        R 4
        U 4
        L 3
        D 2
      DIR

      parsed = Day9.parse_directions(directions)

      expect(parsed).to eq([[4, 0], [0, -4], [-3, 0], [0, 2]])
    end
  end

  context "rope" do
    before :each do
      @rope = Rope.new
    end

    it "moves" do
      expect(@rope.head).to eq([0, 0])

      @rope.move([1, 0])
      expect(@rope.head).to eq([1, 0])

      @rope.move([0, 1]) # move one down
      expect(@rope.head).to eq([1, 1])
    end

    it "can tell the distance between tail and head" do
      # They start at the same position
      expect(@rope.head).to eq(@rope.tail)
      expect(@rope.length).to eq(0)

      @rope.head = [0, 1] # down
      expect(@rope.length).to eq(1)
      expect(@rope).to be_adjacent

      @rope.head = [10, 11] # down
      @rope.tail = [10, 10] # down
      expect(@rope.length).to eq(1)
      expect(@rope).to be_adjacent

      @rope.head = [0, 2] # down by two
      @rope.tail = [0, 0] # down
      expect(@rope.length).to eq(2)
      expect(@rope).to_not be_adjacent

      @rope.head = [0, -1] # up
      expect(@rope.length).to eq(1)
      expect(@rope).to be_adjacent

      @rope.head = [1, 0] # right
      expect(@rope.length).to eq(1)
      expect(@rope).to be_adjacent

      @rope.head = [-1, 0] # left
      expect(@rope.length).to eq(1)
      expect(@rope).to be_adjacent

      @rope.head = [1, 1] # lower right
      expect(@rope.length).to eq(2)
      expect(@rope).to be_adjacent

      @rope.head = [1, -1] # upper right
      expect(@rope.length).to eq(2)
      expect(@rope).to be_adjacent

      @rope.head = [-1, 1] # lower left
      expect(@rope.length).to eq(2)
      expect(@rope).to be_adjacent

      @rope.head = [-1, -1] # upper left
      expect(@rope.length).to eq(2)
      expect(@rope).to be_adjacent
    end

    it "is not adjacent if too far off" do
      (2..30).each do |d|
        @rope.head = [0, d]
        expect(@rope).to_not be_adjacent
        @rope.head = [0, -d]
        expect(@rope).to_not be_adjacent
        @rope.head = [d, 0]
        expect(@rope).to_not be_adjacent
        @rope.head = [-d, 0]
        expect(@rope).to_not be_adjacent
      end
    end

    context "the tail" do
      before :each do
        @rope = Rope.new
      end

      it "does not follow the head when they are next to each other in any direction" do
        @rope.move([1, 0])
        expect(@rope).to be_adjacent
        expect(@rope.tail).to eq([0, 0])
      end

      it "records where the tail was" do
        expect(@rope.distinct_tail_positions).to eq(1)

        @rope.move([2, 0])
        expect(@rope.distinct_tail_positions).to eq(2)

        @rope.move([1, 0])
        expect(@rope.distinct_tail_positions).to eq(3)

        @rope.move([-2, 0])
        expect(@rope.distinct_tail_positions).to eq(3)
      end

      it "follows the head to the right" do
        20.times do |expected_tail_pos|
          # We move one step per loop. In the very first iteration, we expect the tail
          # to stay (0). From the next iteration (1) onward, it shall be dragged along (>0)
          @rope.move([1, 0])
          expect(@rope.tail).to eq([expected_tail_pos, 0])
        end
      end

      it "follows leaps to the right" do
        @rope.move([20, 0])
        expect(@rope.tail).to eq([19, 0])
      end

      it "follows the head to the left" do
        20.times do |expected_tail_pos|
          @rope.move([-1, 0])
          expect(@rope.tail).to eq([-expected_tail_pos, 0])
        end
      end

      it "follows the head down" do
        20.times do |expected_tail_pos|
          @rope.move([0, 1])
          expect(@rope.tail).to eq([0, expected_tail_pos])
        end
      end

      it "follows the head up" do
        20.times do |expected_tail_pos|
          @rope.move([0, -1])
          expect(@rope.tail).to eq([0, -expected_tail_pos])
        end
      end

      it "follows diagonally to the down right" do
        @rope.move([1, 0])
        expect(@rope.tail).to eq([0, 0]) # stays there

        @rope.move([0, 1])
        expect(@rope.tail).to eq([0, 0]) # stays there

        @rope.move([0, 1])
        expect(@rope.tail).to eq([1, 1]) # keeps up
      end

      it "follows diagonally to the down left" do
        @rope.move([-1, 0])
        expect(@rope.tail).to eq([0, 0]) # stays there

        @rope.move([0, 1])
        expect(@rope.tail).to eq([0, 0]) # stays there

        @rope.move([0, 1])
        expect(@rope.tail).to eq([-1, 1]) # keeps up
      end

      it "follows diagonally to the top right" do
        @rope.move([1, 0])
        expect(@rope.tail).to eq([0, 0]) # stays there

        @rope.move([0, -1])
        expect(@rope.tail).to eq([0, 0]) # stays there

        @rope.move([0, -1])
        expect(@rope.head).to eq([1, -2])
        expect(@rope.tail).to eq([1, -1]) # keeps up
      end
    end
  end

  context "example task" do
    it "can solve it", focus: true do
      input = <<~STEPS
        R 4
        U 4
        L 3
        D 1
        R 4
        D 1
        L 5
        R 2
      STEPS
      steps = Day9.parse_directions(input)

      rope = Rope.new

      s = steps.shift
      rope.move(s)
      expect(rope.head).to eq([4, 0])
      expect(rope.tail).to eq([3, 0])
      expect(rope.distinct_tail_positions).to eq(4)

      s = steps.shift
      rope.move(s)
      expect(rope.head).to eq([4, -4])
      expect(rope.tail).to eq([4, -3])
      expect(rope.distinct_tail_positions).to eq(7)
    end
  end
end
