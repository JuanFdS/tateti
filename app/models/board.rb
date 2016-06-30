require_relative '../../app/models/squared_matrix'
require_relative '../../app/models/line'

class Board

  attr_reader :matrix

  def self.new_empty(size)
    new(SquaredMatrix.new(Array.new(size).map{|_| Array.new(size)}))
  end

  def initialize(matrix)
    @matrix = matrix
  end

  def all_lines
    rows + columns + diagonals
  end

  def size
    matrix.size
  end

  [:rows, :columns, :diagonals].each do |method_name|
    define_method(method_name) do
      matrix.send(method_name).map {|line| Line.new line}
    end
  end

  def full?
    matrix.all? {|cell| !cell.nil?}
  end

  def available_positions
    matrix.positions.select {|position| is_available(position)}
  end

  def is_available(position)
    matrix.cell(position).nil?
  end

  def validate(position)
    raise OutOfBoardException unless position.all? {|coord| coord < size}
    raise OccupiedPositionException unless is_available(position)
  end

  def put(play)
    validate(play.position)
    Board.new(matrix.put(play.symbol, play.position))
  end

  def ==(other_board)
    matrix == other_board.matrix
  end

  def cells
    matrix.cells
  end


end