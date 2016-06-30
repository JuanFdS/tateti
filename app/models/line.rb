class Line

  attr_reader :array

  def initialize(array)
    @array = array
  end

  def win?(sym = nil)
    sym = sym
    sym ||= array.first
    array.all? {|value| value == sym && !value.nil? }
  end

  def ==(other_line)
    self.array == other_line.array
  end

end
