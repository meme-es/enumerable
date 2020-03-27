require './utils'

module Enumerable
  def my_each
    return to_enum unless block_given?

    length.times { |index| yield(self[index]) }
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    length.times { |index| yield(self[index], index) }
    self
  end

  def my_select
    return to_enum unless block_given?

    array = []
    my_each { |item| array << item if yield(item) }
    array
  end

  def my_all?(parameter = nil)
    return my_all_param(parameter) unless parameter.nil?

    if block_given?
      my_each { |item| return false unless yield(item) }
    else
      my_each { |item| return false if item.nil? || item == false }
    end
    true
  end

  def my_any?(parameter = nil)
    return my_any_param(parameter) unless parameter.nil?

    if block_given?
      my_each { |item| return true if yield(item) }
    else
      my_each { |item| return true if !item.nil? && item != false }
    end
    false
  end

  def my_none?(parameter = nil)
    return my_none_param(parameter) unless parameter.nil?

    return no_block_given unless block_given?

    my_each { |item| return false if yield(item) }
    true
  end

  def my_count(parameter = :no_parameter)
    counter = 0
    if parameter != :no_parameter
      my_each { |item| counter += 1 if item == parameter }
      return counter
    end

    if block_given?
      my_each { |item| counter += 1 if yield(item) }
    else
      my_each { counter += 1 }
    end
    counter
  end

  def my_map
    newarray = []
    return to_enum unless block_given?

    length.times { |index| newarray << yield(self[index]) }
    newarray
  end

  def my_inject(param_a = nil, param_b = nil)
    tmp_array = to_a + []
    tmp_array.unshift(param_a) if literal?(param_a)
    return evaluate_with(tmp_array, param_b) if param_a && param_b
    return evaluate_with(tmp_array, param_a) if !param_a.nil? && !literal?(param_a)

    result = tmp_array.shift
    tmp_array.my_each { |item| result = yield result, item }

    result
  end
end
