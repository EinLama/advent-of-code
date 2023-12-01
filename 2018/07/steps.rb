class Step
  attr_accessor :name, :parents, :children

  def initialize(name)
    @name = name
    @parents = []
    @children = []
  end

  def ready?
    @parents.empty?
  end

  def to_s
    "<Step #{name}, c:#{@children.map(&:name)}, p:#{@parents.map(&:name)}>"
  end

  def adopt_child(child)
    @children << child
    child.parents << self
  end
end

def adjust_available_steps(list, step)
  i = 0
  while i < list.size && list[i].name < step.name
    i += 1
  end

  list.insert(i, step)
end

def steps()
  steps = {}

  File.open("input").each do |l|
    parent, child = /^Step ([A-Z]).*step ([A-Z]) can begin\./.match(l)[1,2]

    steps[parent] = Step.new(parent) unless steps.key?(parent)
    steps[child] = Step.new(child) unless steps.key?(child)

    steps[parent].adopt_child(steps[child])
  end

  available = []
  done = []

  # determine starting nodes
  steps.values.find_all { |s| s.ready? }.each do |step|
    adjust_available_steps(available, step)
  end

  until available.empty?
    # consume next available node
    nex = available.shift
    done << nex.name

    nex.children.each do |c|
      # inform children that their parent has been consumed
      c.parents.delete(nex)
      adjust_available_steps(available, c) if c.ready?
    end
  end

  done.join("")
end

puts steps()

