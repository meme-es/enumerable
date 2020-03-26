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
end
