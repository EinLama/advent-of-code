
class Node
  attr_accessor :num_childs, :num_metadata, :metadatas, :children
  @@id = 1

  def initialize(num_childs, num_metadata)
    @id = @@id
    @@id += 1
    @num_childs = num_childs
    @num_metadata = num_metadata

    @children = []
    @metadatas = []
  end

  def to_s
    "<Node##{@id} c:#{@num_childs} m:#{@num_metadata} m:#{@metadatas}>"
  end

  def total_metadata
    total = @metadatas.inject(:+)

    unless @children.empty?
      total += @children.map(&:total_metadata).inject(:+)
    end

    total
  end
end

numbers = File.open("input").read.split(" ").map(&:to_i)
#p numbers

def consume_node(nodelist)
  node = Node.new(nodelist.shift, nodelist.shift)

  (0...(node.num_childs)).each do |i|
    node.children << consume_node(nodelist)
  end
  (0...(node.num_metadata)).each do |i|
    metadata = nodelist.shift
    node.metadatas << metadata
  end

  node
end

root = consume_node(numbers)
puts root.total_metadata

