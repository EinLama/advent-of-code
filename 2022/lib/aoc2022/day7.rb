# frozen_string_literal: true

module Aoc2022
  module Day7
    class NoSuchDirError < StandardError; end

    class Dirz
      attr_reader :name, :contents
      attr_accessor :parent

      def initialize(name)
        @name = name
        @contents = []
        @parent = nil
      end

      def insert!(dir)
        # reset cache
        @size = nil

        contents << dir
        dir.parent = self
      end

      def dirs
        contents.filter { |f| f.is_a?(Dirz) }
      end

      def find(name)
        contents.find { |d| d.is_a?(Dirz) && d.name == name }
      end

      def include?(child)
        contents.include?(child)
      end

      def size
        # Cache the result so we don't calculate multiple times
        @size ||= contents.inject(0) { |i, f| i + f.size }
      end

      def to_s
        ["#{name}/"].concat(contents.map(&:to_s)).join("\n")
      end
    end

    class Filez
      attr_reader :name, :size
      attr_accessor :parent

      def initialize(name, size)
        @name = name
        @size = size
        @parent = nil
      end

      def to_s
        "#{name} #{size}"
      end
    end

    class Sysz
      attr_reader :current_dir, :root_dir

      def exec!(instruction)
        cmd, args = instruction

        case cmd
        when :cd
          cd(args)
        when :ls
          ls(args)
        end

        @current_dir
      end

      def big_dirs(directory = nil)
        directory ||= @root_dir
        dirs = directory.dirs

        directory.dirs.each do |d|
          dirs.concat(big_dirs(d))
        end

        dirs
      end

      def total_sys_size
        @total_sys_size ||= @root_dir.size
      end

      def smallest_dir(directory = nil, smallest_size = nil)
        directory ||= @root_dir
        dirs = directory.dirs

        dirs.each do |d|
          dirsize = d.size
          if total_sys_size - dirsize <= 40_000_000
            smallest_size ||= dirsize
            smallest_size = dirsize if smallest_size > dirsize
          end

          smallest_size = smallest_dir(d, smallest_size)
        end

        smallest_size
      end

      def to_s
        "SYS\n#{@root_dir}"
      end

      private

      def cd(args)
        if args == ".."
          @current_dir = @current_dir.parent
        else
          new_dir = Dirz.new(args)

          @root_dir ||= new_dir

          # Avoid duplicates
          if (existing_child = @current_dir&.find(args))
            @current_dir = existing_child
          else
            @current_dir&.insert!(new_dir)
            @current_dir = new_dir
          end
        end
      end

      def ls(args)
        args.each do |type, *rest|
          case type
          when :file
            @current_dir.insert!(Filez.new(rest.last, rest.first))
          when :dir
            @current_dir.insert!(Dirz.new(rest.first))
          end
        end
      end
    end

    class Tokenizer
      attr_reader :tokens

      def self.regex
        %r{\$|cd|ls|dir|\.\.|\w+\.?\w+|\w+|/}
      end

      def initialize(str)
        @tokens = read(str)
      end

      def peek_next
        @tokens.first
      end

      def next_token
        token = @tokens.shift

        case token
        when "$"
          next_token
        when "cd"
          [:cd, next_token]
        when "ls"
          ls = [:ls, []]

          loop do
            nt = peek_next
            break if %w[$ cd ls].include?(nt)
            break unless nt

            ls[1] << next_token
          end

          ls
        when "dir"
          [:dir, next_token]
        when /\d+/
          [:file, token.to_i, next_token]
        else
          token # return the plain string or number
        end
      end

      private

      def read(str)
        str.scan(Tokenizer.regex)
      end
    end

    module_function

    def solve_example(input)
      solve_part1(input)
    end

    def solve_part1(input)
      tokens = Tokenizer.new(input)

      sys = Sysz.new
      while (t = tokens.next_token)
        sys.exec!(t)
      end

      biggest_dirs = sys.big_dirs
      biggest_dirs.map(&:size).reject { |s| s > 100_000 }.sum
    end

    def solve_part2(input)
      tokens = Tokenizer.new(input)

      sys = Sysz.new
      while (t = tokens.next_token)
        sys.exec!(t)
      end

      sys.smallest_dir
    end
  end
end
