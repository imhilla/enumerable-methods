module Enumerable
  def my_each
    i = 0
    while i < size
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    i = 0
    while i < size
      yield(self[i], i)
      i =+ 1
    end
    self
  end

  def my_select
    return enum_for unless block_given?
    array = []
    array.my_each do |i|
      array.push(i) if yield(i) == true
    end
    array
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

  def my_map
  
  end

  def my_inject
   
  end

end
