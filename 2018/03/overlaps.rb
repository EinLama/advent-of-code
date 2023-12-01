class Rect
  attr_reader :id, :x, :y, :w, :h

  def initialize(str)
    parsed = /^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/.match(str)
    @id = parsed[1].to_i
    @x = parsed[2].to_i
    @y = parsed[3].to_i
    @w = parsed[4].to_i
    @h = parsed[5].to_i
  end

  def to_s
    "<Rect ##{id} #{x},#{y}: #{w}x#{h}>"
  end

  def coords()
    (@x...(@x+@w)).map do |x|
      (@y...(@y+@h)).map do |y|
        "#{x},#{y}"
      end
    end.flatten
  end
end

class World
  def initialize
    @world = Hash.new(".")
  end

  def place(rect)
    coords = rect.coords()

    coords.each do |point|
      if @world[point] != "."
        @world[point] = "X"
      else
        @world[point] = rect.id
      end
    end
  end

  def count_overlaps
    @world.count { |k, v| v == "X" }
  end

  def to_s
    str = ""
    (0..20).each do |y|
      (0..20).each do |x|
        str << @world["#{x},#{y}"].to_s
      end
      str << "\n"
    end
    str
  end
end

def overlap()
  world = World.new
  rects = File.open("input03").map { |l| Rect.new(l) }

  rects.each do |rect|
    world.place(rect)
  end

  world.count_overlaps()
end

puts overlap()