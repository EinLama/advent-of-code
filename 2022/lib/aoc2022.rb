# frozen_string_literal: true

require "optparse"

Dir[File.join(__dir__, "aoc2022", "*.rb")].sort.each { |file| require file }

module Aoc2022
  class Error < StandardError; end

  module_function

  # Reads a file from `input/`, expects the filename without
  # folder or path.
  #
  # read_input("1_example.txt") # will read and return `input/1_example.txt`
  def read_input(filename)
    File.read(File.join("input", filename))
  end
end

if __FILE__ == $PROGRAM_NAME
  options = {}
  OptionParser.new do |opts|
    opts.on("-dDAY", "--day=DAY", "Choose day as integer.") do |d|
      options[:day] = d
    end

    opts.on("-pPART", "--part=PART", "Choose a part (1, 2, [e]xample)") do |p|
      p = "part#{p}" if %w[1 2].include?(p)
      p = "example" if p == "e"
      options[:part] = p
    end

    opts.on("-v", "--verbose", "Display parsed options") do |v|
      options[:verbose] = v
    end
  end.parse!

  file_suffix = if options[:part] == "example"
                  "_example.txt"
                else
                  ".txt"
                end

  options[:filename] = "#{options[:day]}#{file_suffix}"

  p options if options[:verbose]

  input = Aoc2022.read_input(options[:filename])
  clazz = Aoc2022.const_get("Day#{options[:day]}")

  puts clazz.public_send("solve_#{options[:part]}", input)
end
