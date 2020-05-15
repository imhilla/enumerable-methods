# rubocop: disable Metrics/ModuleLength
# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
module Enumerable
  def my_each
    return to_enum :my_each unless block_given?

    i = 0
    while i < size

      case self.class.name
      when 'Hash' then yield(keys[i], self[keys[i]])
      when 'Array' then yield(self[i])
      when 'Range' then yield(to_a[i])
      end
      i += 1
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

  def my_all?(pattern = nil)
    if pattern.nil?
      if block_given?
        my_each { |value| return false unless yield(value) }
      else my_each { |value| return false unless value }
      end
    elsif pattern.is_a?(Regexp)
      my_each { |value| return false unless value.match(pattern) }
    elsif pattern.is_a?(Module)
      my_each { |value| return false unless value.is_a?(pattern) }
    else
      my_each { |value| return false unless value == pattern }
    end
    true
  end

  def my_any?(pattern = nil)
    if pattern.nil?
      if block_given?
        my_each { |value| return true if yield(value) }
      else my_each { |value| return true if value }
      end
    elsif pattern.is_a?(Regexp)
      my_each { |value| return true if value.match(pattern) }
    elsif pattern.is_a?(Module)
      my_each { |value| return true if value.is_a?(pattern) }
    else
      my_each { |value| return true if value == pattern }
    end
    false
  end

  def my_none?(pattern = nil)
    if pattern.nil?
      if block_given?
        my_each { |value| return false if yield(value) }
      else my_each { |value| return false if value }
      end
    elsif pattern.is_a?(Regexp)
      my_each { |value| return false if value.match(pattern) }
    elsif pattern.is_a?(Module)
      my_each { |value| return false if value.is_a?(pattern) }
    else
      my_each { |value| return false if value == pattern }
    end
    true
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

# tests
[1, 2, 3].my_each do |n|
  text = "Current number is: #{n}"
  puts text
end

a = [18, 22, 33, 3, 5, 6]
puts "my_select method :#{a.my_select { |num| num > 10 }}\n\n"

enu1 = [10, 19, 18]
res1 = enu1.my_all? { |num| num > 4 }
puts res1

enu1 = [10, 19, 18]
res1 = enu1.none? { |num| num > 4 }
puts res1

enu1 = [10, 19, 18]
res1 = enu1.any? { |num| num > 4 }
puts res1

a = [18, 22, 33, nil, 5, 6]
puts "counting : #{a.my_count}\n\n"

a = [18, 22, 33, 3, 5, 6]
puts "map method :#{a.my_map { |num| num > 10 }}\n\n"

def sum(array)
  array.my_inject(0) { |sum, num| sum + num }
end
p sum([5, 10, 20])
