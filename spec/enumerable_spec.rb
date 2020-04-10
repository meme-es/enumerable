# spec/enumerable_spec.rb

require './enumerable'

RSpec.describe Enumerable do
  let(:numbers) { [10, 20, 30, 40, 3] }
  let(:str_numbers) { %w[5 10 15 20 25] }
  let(:animals) { %w[eagle camel horse hyena] }
  let(:birds) { %w[crow peacock turkey pigeon] }
  let(:num_with_nil) { [1, 2, 3, 4, nil] }
  let(:same_num) { [5, 5, 5, 5, 5] }

  describe '#my_each' do
    context 'when there is no block given' do
      it 'returns enum' do
        expect(numbers.my_each).to be_an_instance_of(Enumerator)
      end
    end

    context 'when there is a block given' do
      it 'returns self' do
        expect(numbers.my_each { |item| item + 5 }).to eql(numbers)
      end
    end
  end

  describe '#my_each_with_index' do
    context 'when there is no block given' do
      it 'returns enum' do
        expect(numbers.my_each_with_index).to be_an_instance_of(Enumerator)
      end
    end

    context 'when there is a block given' do
      it 'returns self' do
        expect(numbers.my_each_with_index { |value, _index| value + 5 }).to eql(numbers)
      end
    end
  end

  describe '#my_select' do
    context 'when there is no block given' do
      it 'returns enum' do
        expect(numbers.my_select).to be_an_instance_of(Enumerator)
      end
    end

    context 'when there is a block given' do
      it 'returns an array with the matching elements of the block operation' do
        expect(numbers.my_select { |item| item > 10 }).to eql(numbers.select { |item| item > 10 })
      end
    end

    context 'when there is a block given as an argument' do
      it 'returns an array with the matching elements of the operation' do
        expect(numbers.my_select(&:even?)).to eql(numbers.select(&:even?))
      end
    end
  end

  describe '#my_all?' do
    context 'when there is no block given' do
      it 'returns true if there is not nil or false items' do
        expect(animals.my_all?).to eql(animals.all?)
      end

      it 'returns false if any of the items is nil or false' do
        expect(num_with_nil.my_all?).to eql(num_with_nil.all?)
      end

      it 'returns true if the array is empty' do
        expect([].my_all?).to eql([].all?)
      end
    end

    context 'when there is a block given' do
      it 'returns true if all items pass the block test' do
        expect(birds.my_all? { |item| item.length >= 4 }).to eql(birds.all? { |item| item.length >= 4 })
      end

      it "returns false if any item doesn't pass the block test" do
        expect(birds.my_all? { |item| item.length == 6 }).to eql(birds.all? { |item| item.length == 6 })
      end
    end

    context 'when there is an argument given as' do
      context 'a literal' do
        it 'returns true if all elements have the same value' do
          expect(same_num.my_all?(5)).to eql(same_num.all?(5))
        end

        it "returns false if any elements haven't the same value" do
          expect(numbers.my_all?(3)).to eql(numbers.all?(3))
        end
      end

      context 'a regular expression' do
        it 'returns true if all items match the given expression' do
          expect(animals.my_all?(/e/)).to eql(animals.all?(/e/))
        end

        it "returns false if any item doesn't match the given expression" do
          expect(animals.my_all?(/a/)).to eql(animals.all?(/a/))
        end
      end

      context 'a class' do
        it 'returns true if all elements are instances of the class given' do
          expect(numbers.my_all?(Integer)).to eql(numbers.all?(Integer))
        end

        it "returns false if any element isn't an instance of the class given" do
          expect(num_with_nil.my_all?(Integer)).to eql(num_with_nil.all?(Integer))
        end
      end
    end
  end

  describe '#my_any?' do
    context 'when there is no block given' do
      it 'returns false if the array is empty' do
        expect([].my_any?).to eql([].any?)
      end

      it 'returns false if all items are nil or false' do
        expect([false, false, false].my_any?).to eql([false, false, false].any?)
      end

      it 'returns true if any element is different to nil and false' do
        expect(num_with_nil.my_any?).to eql(num_with_nil.any?)
      end
    end

    context 'when there is a block given' do
      it 'returns true if any element pass the block test' do
        expect(birds.my_any? { |item| item.length == 6 }).to eql(birds.any? { |item| item.length == 6 })
      end

      it 'returns false if none of the elements pass the block test' do
        expect(numbers.my_any? { |item| item % 7 == 0 }).to eql(numbers.any? { |item| item % 7 == 0 })
      end
    end

    context 'when there is an argument given as' do
      context 'a literal' do
        it 'returns true if any element has the same value' do
          expect(numbers.my_any?(3)).to eql(numbers.any?(3))
        end

        it 'returns false if no one element has the same value' do
          expect(numbers.my_any?(100)).to eql(numbers.any?(100))
        end
      end

      context 'a regular expression' do
        it 'returns true if the regular expression match any item' do
          expect(animals.my_any?(/l/)).to eql(animals.any?(/l/))
        end

        it "returns false if the regular expression doesn't match any item" do
          expect(animals.my_any?(/w/)).to eql(animals.any?(/w/))
        end
      end

      context 'a class' do
        it 'returns true if any element is an instance of the class given' do
          expect(['one', 'two', 3].my_any?(Integer)).to eql(['one', 'two', 3].any?(Integer))
        end

        it 'returns false if no one is an instance of the class given' do
          expect(%w[one two three].my_any?(Integer)).to eql(%w[one two three].any?(Integer))
        end
      end
    end
  end

  describe '#my_none?' do
    context 'when there is no block given' do
      it 'returns true if the array is empty' do
        expect([].my_none?).to eql([].none?)
      end

      it 'return true if all items are nil or false' do
        expect([nil, nil, nil].my_none?).to eql([nil, nil, nil].none?)
      end

      it 'return false if any element is not nil or false' do
        expect([nil, nil, 'Hello!'].my_none?).to eql([nil, nil, 'Hello!'].none?)
      end
    end

    context 'when there is a block given' do
      it 'return true if no one item pass the test block' do
        expect(numbers.my_none? { |item| item % 7 == 0 }).to eql(numbers.none? { |item| item % 7 == 0 })
      end
      it 'return false if any item pass the test block' do
        expect(birds.my_none? { |item| item.length == 6 }).to eql(birds.none? { |item| item.length == 6 })
      end
    end

    context 'when there is an argument given as' do
      context 'a literal' do
        it 'returns true if no one element has the same value' do
          expect(numbers.my_none?(100)).to eql(numbers.none?(100))
        end

        it 'returns false if any element has the same value' do
          expect(numbers.my_none?(3)).to eql(numbers.none?(3))
        end
      end

      context 'a regular expression' do
        it "returns true if the regular expression doesn't match any item" do
          expect(animals.my_none?(/w/)).to eql(animals.none?(/w/))
        end

        it 'returns false if the regular expression match any item' do
          expect(animals.my_none?(/l/)).to eql(animals.none?(/l/))
        end
      end

      context 'a class' do
        it 'returns true if no one is an instance of the class given' do
          expect(%w[one two three].my_none?(Integer)).to eql(%w[one two three].none?(Integer))
        end

        it 'returns false if any element is an instance of the class given' do
          expect(['one', 'two', 3].my_none?(Integer)).to eql(['one', 'two', 3].none?(Integer))
        end
      end
    end
  end

  describe '#my_count' do
    context 'when there is no block given' do
      it 'returns the number of elements in the array' do
        expect(numbers.my_count).to eql(numbers.count)
      end
    end

    context 'when there is an argument given as' do
      context 'a literal' do
        it 'returns the number of elements with the same value' do
          expect(numbers.my_count(3)).to eql(numbers.count(3))
        end
      end

      context 'as a block' do
        it 'returns the number of elements that match the block' do
          expect(numbers.my_count(&:even?)).to eql(numbers.count(&:even?))
        end
      end
    end
  end

  describe '#my_map' do
    context 'when there is no block given' do
      it 'returns enum' do
        expect(numbers.my_map).to be_an_instance_of(Enumerator)
      end
    end

    context 'when there is a block given' do
      it 'returns an array with the true or false matching' do
        expect(numbers.my_map { |item| item % 5 == 0 }).to eql(numbers.map { |item| item % 5 == 0 })
      end
    end

    context 'when there is an argument given as a block' do
      it 'returns an array with the true or false matching' do
        expect(numbers.my_map(&:even?)).to eql(numbers.map(&:even?))
      end
    end

    context 'when a range is used in combination with a block given' do
      it 'returns an array with elements given by the processing of the block' do
        expect((1..5).my_map { |i| i * i }).to eql((1..5).map { |i| i * i })
      end
    end
  end
end
