module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?
    
    for i in self
      yield i
    end
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?
    i = 0
    while i < size
      yield(self[i], i)
      i =+ 1
    end
    self
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

  def my_all?(pattern)
    if pattern.nil?
      if block_given?
        my_each { |value| return false unless yield(value)}
      else
        my_each { |value| return false unless value}
      end
    elsif pattern.is_a?(Regexp)
      my_each { |value| return false unless value.match(pattern) }
    elsif pattern.is_a?(Module)
      my_each { |value| return false unless value.is_a?(pattern) }
    else
      my_each { |value| return false unless value == pattern}
    end
    true
  end

  def my_any?(pattern)
    if pattern.nil?
      if block_given?
        my_each { |value| return true if yield(value)}
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

  def my_none?(pattern)
    if pattern.nil?
      if block_given?
        my_each { |value| return false if yield(value)}
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

  def my_count
    count = 0
    self.my_each do |i|
      if block_given?
        count += 1 if yield(i)
      else
        count += 1
      end
    end
    count
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
        lambda { |acc, value| acc.send(operation, value) }
      when nil
        block
      else
      raise ArgumentError, "the operation provided must be a symbol"
    end
    if accumulator.nil?
      ignore_first = true
      accumulator = first
    end
    index = 0
    my_each do |element|
      unless ignore_first && index == 0
        accumulator = block.call(accumulator, element)
      end
      index += 1
    end
    accumulator
  end

end
