# frozen_string_literal: true

Day7 = Aoc2022::Day7
Sysz = Day7::Sysz
Dirz = Day7::Dirz
Filez = Day7::Filez
Tokenizer = Day7::Tokenizer

RSpec.describe Aoc2022::Day7 do
  context "Dirz" do
    it "has a name and is empty by default" do
      dir = Dirz.new("a")
      expect(dir.name).to eq("a")
      expect(dir.contents).to eq([])
      expect(dir.size).to eq(0)
    end

    it "can contain other directories" do
      dir = Dirz.new("a")
      dir_b = Dirz.new("b")
      dir.insert!(dir_b)

      expect(dir.name).to eq("a")
      expect(dir.contents).to eq([dir_b])
      expect(dir.size).to eq(0)

      # it's directories all the way down!
      expect(dir.contents.first.contents).to eq([])
    end

    it "can contain files" do
      dir = Dirz.new("a")
      f = Filez.new("file", 45)

      dir.insert!(f)
      expect(dir.contents).to eq([f])
      expect(dir.size).to eq(45)
    end

    it "calculates size recursively" do
      dir = Dirz.new("a")
      f = Filez.new("file", 45)
      dir_b = Dirz.new("b")
      f2 = Filez.new("file2", 3)

      dir_b.insert!(f2)
      dir.insert!(f)
      dir.insert!(dir_b)

      expect(dir.contents).to eq([f, dir_b])
      expect(dir.size).to eq(45 + 3)
    end

    it "has no parent on the uppest level" do
      dir = Dirz.new("a")
      expect(dir.parent).to be nil
    end

    it "finds a direct child folder by name" do
      dir = Dirz.new("a")
      b = Dirz.new("b")
      c = Dirz.new("c")
      d = Dirz.new("d")

      dir.insert!(b)
      # Inserting a file as a decoy. It shall not be found, we only want directories:
      dir.insert!(Filez.new("c", 123_123))
      dir.insert!(c)
      dir.insert!(d)

      found = dir.find("c")
      expect(c).to eq(found)
    end

    it "has a parent if inserted" do
      parent = Dirz.new("a")
      child = Dirz.new("b")
      parent.insert!(child)

      expect(parent.parent).to be nil
      expect(child.parent).to eq(parent)
    end
  end

  context "Filez" do
    it "has a name and a size" do
      file = Filez.new("some name", 123)
      expect(file.name).to eq("some name")
      expect(file.size).to eq(123)
    end
  end

  context "Sysz" do
    it "begins empty" do
      sys = Sysz.new
      expect(sys.current_dir).to be_nil
    end

    it "can cd into root" do
      sys = Sysz.new
      sys.exec!([:cd, "/"])

      expect(sys.current_dir).to be_a(Dirz)
      expect(sys.current_dir.name).to eq("/")
      expect(sys.current_dir.contents).to be_empty
    end

    it "can cd into another folder" do
      sys = Sysz.new
      root_dir = sys.exec!([:cd, "/"])
      sys.exec!([:cd, "a"])

      expect(sys.current_dir.name).to eq("a")
      expect(sys.current_dir.parent).to eq(root_dir)
    end

    it "can cd up" do
      sys = Sysz.new
      root_dir = sys.exec!([:cd, "/"])
      sys.exec!([:cd, "a"])
      upped = sys.exec!([:cd, ".."])

      expect(sys.current_dir).to eq(root_dir)
      expect(root_dir).to eq(upped)
    end

    it "does not create a copy when changing directories multiple times" do
      sys = Sysz.new
      sys.exec!([:cd, "/"])
      original_a = sys.exec!([:cd, "a"])
      sys.exec!([:cd, ".."])
      second_a = sys.exec!([:cd, "a"])

      expect(sys.current_dir).to eq(second_a)
      expect(original_a).to eq(second_a)
      expect(sys.current_dir.contents).to be_empty
    end

    it "creates files when listing" do
      sys = Sysz.new
      sys.exec!([:cd, "/"])
      sys.exec! [:ls, [[:file, 100, "a"]]]

      expect(sys.current_dir.contents.size).to eq(1)
      file = sys.current_dir.contents.first

      expect(file).to be_a(Filez)
      expect(file.name).to eq("a")
      expect(file.size).to eq(100)
    end

    it "creates folders when listing" do
      sys = Sysz.new
      sys.exec!([:cd, "/"])
      sys.exec! [:ls, [[:dir, "folder"], [:file, 232, "fyle"]]]

      expect(sys.current_dir.contents.size).to eq(2)
      dir = sys.current_dir.contents.first
      file = sys.current_dir.contents.last

      expect(dir).to be_a(Dirz)
      expect(dir.name).to eq("folder")
      expect(file.size).to eq(232)
    end

    it "can count files more than once in nested dirs" do
      sys = Sysz.new
      sys.exec!([:cd, "/"])
      sys.exec!([:cd, "a"])
      sys.exec!([:ls, [[:file, 300, "upper file"]]])
      sys.exec!([:cd, "b"])
      sys.exec!([:ls, [[:file, 800, "small file"], [:file, 100, "tiny file"]]])

      big_dirs = sys.big_dirs

      expect(big_dirs.size).to eq(2)
      expect(big_dirs.first.size).to eq(300 + 800 + 100)
      expect(big_dirs.last.size).to eq(800 + 100)
    end
  end

  context "Tokenizer" do
    input = <<~INPUT
      $ cd /
      $ ls
      dir a
      14848514 b.txt
      $ cd a
      $ cd ..
    INPUT

    it "recognizes tokens" do
      tokenizer = Tokenizer.new(input)

      expect(tokenizer.tokens).to eq(%w[$ cd / $ ls dir a 14848514 b.txt $ cd a $ cd ..])
      cd = tokenizer.next_token

      expect(cd).to eq([:cd, "/"])
      expect(tokenizer.tokens).to eq(%w[$ ls dir a 14848514 b.txt $ cd a $ cd ..])

      ls = tokenizer.next_token
      expect(ls).to eq([:ls, [[:dir, "a"], [:file, 14_848_514, "b.txt"]]])

      cd_a = tokenizer.next_token
      expect(cd_a).to eq([:cd, "a"])
      cd_up = tokenizer.next_token
      expect(cd_up).to eq([:cd, ".."])

      expect(tokenizer.tokens).to eq([])
    end
  end
end
