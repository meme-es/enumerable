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

    (my_each { |item| return false unless yield(item) }) if block_given?

    my_each { |item| return false if item.nil? || item == false }
    true
  end

  def my_all_param(parameter)
    if parameter.class == Class
      my_all? { |item| item.class == parameter }
    elsif parameter.class == Regexp
      my_all? { |item| item.match(parameter) }
    else
      my_all? { |item| item == parameter }
    end
  end

  def my_any?(parameter = nil)
    return my_any_param(parameter) unless parameter.nil?

    (my_each { |item| return true if yield(item) }) if block_given?

    my_each { |item| return true if !item.nil? && item != false }
    false
  end

  def my_any_param(parameter)
    if parameter.class == Class
      my_any? { |item| item.class == parameter }
    elsif parameter.class == Regexp
      my_any? { |item| item.match(parameter) }
    else
      my_any? { |item| item == parameter }
    end
  end

  def my_none?(parameter = nil)
    return my_none_param(parameter) unless parameter.nil?

    return no_block_given unless block_given?

    my_each { |item| return false if yield(item) }
    true
  end

  def no_block_given
    return true if (length == 1 && self[0]) || empty?

    my_each { |item| return false if item }

    true
  end

  def my_none_param(parameter)
    if parameter.class == Class
      my_none? { |item| item.class == parameter }
    elsif parameter.class == Regexp
      my_none? { |item| item =~ parameter }
    else
      my_none? { |item| item == parameter }
    end
  end
end
