class Point
  attr_accessor :x, :y, :vel_x, :vel_y

  def initialize(x, y, vel_x, vel_y)
    @x = x; @y = y
    @vel_x = vel_x; @vel_y = vel_y
  end

  def move
    Point.new(x + vel_x, y + vel_y, vel_x, vel_y)
  end

  def coords
    [x, y]
  end

  def neighbour_locations
    [
      [x-1, y],
      [x+1, y],
      [x, y-1],
      [x, y+1],
    ]
  end

  def to_s
    "<Point #{x},#{y} #{vel_x},#{vel_y}>"
  end
end

def draw(world={}, lower_border, upper_border)
  (lower_border..upper_border).each do |y|
    (lower_border..upper_border).each do |x|
      print world[[x,y]]
    end
    puts "\n"
  end
end

def count_points_with_neighbours(world={}, points=[])
  neighbours = 0
  points.each do |p|
    p.neighbour_locations.each do |n|
      if world[n] == "#"
        neighbours += 1
      end
    end
  end

  neighbours
end

def next_generation(points=[])
  points.map(&:move)
end

def parse_line(line)
  line.scan(/\-?\d+/).map(&:to_i)
end

def build_world(points=[])
  world = Hash.new(".")
  points.each do |p|
    world[p.coords] = "#"
  end

  world
end

points = File.open("input").map do |line|
  Point.new(*parse_line(line))
end


generation = 1
loop do
  puts "######## DRAWING #{generation} ##########"
  borders = [
    points.map(&:x).min,
    points.map(&:x).max,
    points.map(&:y).min,
    points.map(&:y).max,
  ]

  world = build_world(points)

  neighbours = count_points_with_neighbours(world, points)
  if neighbours > points.size
    draw(world, borders.min, borders.max)
    sleep 1
  else
    puts "counted #{neighbours}: Skipping #{generation}..."
  end
  points = next_generation(points)
  puts

  generation += 1
end

