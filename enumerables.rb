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
    array = []
    array.my_each do |i|
      array.push(i) if yield(i) == true
    end
    array
  end

  def my_all
    array.my_each do |i|
    if yield(i) == false
      return false
    end
    return true
  end






end