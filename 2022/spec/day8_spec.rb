# frozen_string_literal: true

Day8 = Aoc2022::Day8
World = Aoc2022::Day8::World

RSpec.describe Day8 do
  trees = <<~TREE
    30373
    25512
    65332
    33549
    35390
  TREE

  context "world" do
    it "can pinpoint a tree" do
      w = World.new("123\n345")

      expect(w.tree_at(0, 0)).to eq(1)
      expect(w.tree_at(1, 0)).to eq(2)
      expect(w.tree_at(1, 1)).to eq(4)
    end

    it "has a width and height" do
      w = World.new("123\n345")
      expect(w.width).to eq(3)
      expect(w.height).to eq(2)
    end
  end

  context "tree visibility" do
    before :each do
      @world = World.new(trees)
    end

    it "is visible when at the edge of the world" do
      (1..4).each do |x|
        expect(@world.tree_visible?(x, 0)).to be true # top side
        expect(@world.tree_visible?(0, x)).to be true # left side

        expect(@world.tree_visible?(4, x)).to be true # right side
        expect(@world.tree_visible?(x, 4)).to be true # bottom side
      end
    end

    it "is visible when visible from any direction" do
      expect(@world.tree_visible?(1, 1)).to be true
      expect(@world.tree_visible?(2, 1)).to be true
      expect(@world.tree_visible?(3, 1)).to be false
      expect(@world.tree_visible?(2, 2)).to be false

      expect(@world.tree_visible?(2, 3)).to be true
      expect(@world.tree_visible?(1, 3)).to be false
      expect(@world.tree_visible?(3, 3)).to be false
    end

    it "is visible from the left if all neightbors left of it are shorter" do
      expect(@world.check_left(5, 1, 1)).to be true # 2_5_
      expect(@world.check_left(5, 1, 1)).to be true # 2_5_
      expect(@world.check_left(5, 2, 3)).to be true # 33_5_
      expect(@world.check_left(4, 3, 3)).to be false # 335_4_
    end

    it "is visible from the right if all neightbors right of it are shorter" do
      expect(@world.check_right(5, 2, 1)).to be true # _5_12
      expect(@world.check_right(3, 3, 2)).to be true # _3_2
      expect(@world.check_right(4, 3, 3)).to be false # _4_9
    end

    it "is visible from the top if all neightbors up of it are shorter" do
      expect(@world.check_top(5, 1, 1)).to be true
      expect(@world.check_top(5, 2, 1)).to be true
      expect(@world.check_top(5, 1, 2)).to be false
    end
  end

  context "scenic score" do
    before :each do
      @world = World.new(trees)
    end

    it "calculates the score" do
      expect(@world.scenic_score(2, 1)).to eq(4)
      expect(@world.scenic_score(2, 3)).to eq(8)
    end
  end
end
