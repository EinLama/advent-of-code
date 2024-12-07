# frozen_string_literal: true

example = <<~EXMP
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
EXMP

input = File.read(File.join(File.dirname(__FILE__), "day07.txt"))
# input = example

equations = input.split("\n").map do
  result, ops = _1.split(": ")
  [result.to_i].concat(ops.split.map(&:to_i))
end

def gen_permutations(numbers)
  operators = %i[+ *]

  operator_slots = numbers.size - 1
  operator_combinations = operators.repeated_permutation(operator_slots).to_a

  operator_combinations.map do |ops|
    numbers.zip(ops).flatten.compact
  end
end

def calc_expr(expression)
  result = expression[0]

  expression.each_with_index do |item, index|
    next unless item.is_a?(Symbol)

    operator = item
    number = expression[index + 1]

    result = result.send(operator, number)
  end

  result
end

def can_solve?(ex_res, *ops)
  perms = gen_permutations(ops)
  perms.each do |p|
    return true if calc_expr(p) == ex_res
  end

  false
end

r = equations.filter_map do |ex_res, *ops|
  # puts "#{ex_res} => #{ops.inspect}"
  ex_res if can_solve?(ex_res, *ops)
end

pp r.inject(&:+)
