# rubocop: disable Metrics/ModuleLength
# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    each do |num|
      yield(num)
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    my_each do |num|
      yield(num, i)
      i += 1
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    if is_a?(Array)
      array = []
      my_each do |num|
        array << num if yield(num)
      end
      array
    elsif is_a?(Hash)
      hash = {}
      my_each do |key, val|
        hash[key] = val if yield(key, val)
      end
      hash
    end
  end

  def my_all?
    return to_enum(:my_all) unless block_given?

    result = my_select { |x| yield x }
    length == result.length
  end

  def my_any?
    return to_enum(:my_any) unless block_given?

    result = my_select { |x| yield x }
    result.length.positive?
  end

  def my_none?
    return to_enum(:my_none) unless block_given?

    !my_any?
  end

  def my_count(count = nil)
    return count if count
    return length unless block_given?

    my_select { |x| yield x }.length
  end

  def my_map(&block)
    array = []
    each do |i|
      array << block.call(i)
    end
    array
  end

  def my_inject(accumulator = nil, operation = nil, &block)
    block = case operation
            when Symbol
              ->(acc, value) { acc.send(operation, value) }
            when nil
              block
            else
              raise ArgumentError, 'the operation provided must be a symbol'
            end
    if accumulator.nil?
      ignore_first = true
      accumulator = first
    end
    index = 0
    my_each do |element|
      accumulator = block.call(accumulator, element) unless ignore_first && index.zero?
      index += 1
    end
    accumulator
  end
end
# rubocop: enable Metrics/ModuleLength
# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
