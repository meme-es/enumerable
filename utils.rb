def my_all_param(parameter)
  if parameter.class == Class
    my_all? { |item| item.class == parameter }
  elsif parameter.class == Regexp
    my_all? { |item| item.match(parameter) }
  else
    my_all? { |item| item == parameter }
  end
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

def literal?(value)
  operators = '+-*/**|&||&&'
  lit_classes = [String, Integer, FalseClass, TrueClass, Float]
  return false if value.class == String && operators.include?(value)
  return true if !value.nil? && lit_classes.include?(value.class)

  false
end

def evaluate_with(array, operator)
  array.my_inject { |receiver, item| receiver.method(operator).call(item) }
end
