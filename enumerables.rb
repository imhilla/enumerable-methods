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
      my_each { |val| return false unless value.match(pattern) }
    elsif pattern.is_a?(Module)
      my_each { |val| return false unless value.is_a?(pattern) }
    else
      my_each { |value| return false unless value == pattern}
    end
    true
  end

  def my_any?
    select.my_each do |i|
      if yield(i) == true
        return true
      end
    end
    return false
  end

  def my_none?
    self.my_each do |i|
      if yield(i) == true
        return false
      end
    end
    return true
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

  def my_map(a_proc = nil)
    mapped = []
      self.my_each do |i|
        if a_proc && block_given?
          mapped << a_proc.call(yield(i))
        elsif block_given? == false
          mapped << a_proc.call(i)
        end
      end
    mapped
  end

  def my_inject(initial = nil)
    total ||= self.first
    self.my_each_with_index do |value, index|
      unless (index == 0 && total == self.first)
        total = yield(total, value)
      end
    end
    total
  end

end
