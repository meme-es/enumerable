# spec/enumerable_spec.rb

require './enumerable'

RSpec.describe Enumerable do
  let(:numbers) { [10, 20, 30, 40, 3] }
  let(:str_numbers) { %w[5 10 15 20 25] }
  let(:animals) { %w[tigger fox owl camel] }

  describe '#my_each' do
    context 'When there is no block given' do
      it 'returns enum' do
        expect(numbers.my_each).to be_an_instance_of(Enumerator)
      end
    end

    context 'When there is a block given' do
      it 'returns self' do
        expect(numbers.my_each { |item| item + 5 }).to eql(numbers)
      end
    end
  end

  describe '#my_each_with_index' do
    context 'When there is no block given' do
      it 'returns enum' do
        expect(numbers.my_each_with_index).to be_an_instance_of(Enumerator)
      end
    end

    context 'When there is a block given' do
      it 'returns self' do
        expect(numbers.my_each_with_index { |value, _index| value + 5 }).to eql(numbers)
      end
    end
  end

  describe '#my_select' do
    context 'When there is no block given' do
      it 'returns enum' do
        expect(numbers.my_select).to be_an_instance_of(Enumerator)
      end
    end

    context 'When there is a block given' do
      it 'returns an array with the matching elements of the block operation' do
        expect(numbers.my_select { |item| item > 10 }).to eql(numbers.select { |item| item > 10 })
      end
    end

    context 'When there is a operation given as a parameter' do
      it 'returns an array with the matching elements of the operation' do
        expect(numbers.my_select(&:even?)).to eql(numbers.select(&:even?))
      end
    end
  end
end
