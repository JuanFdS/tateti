class SquaredMatrix

  attr_reader :matrix

  def initialize(matrix)
    @matrix = matrix
  end

  def cells
    rows.flatten
  end

  def size
    rows.size
  end

  def cell(position)
    @matrix[position[0]][position[1]]
  end

  def lists_from_matrix(&list_generator)
    last_elem_index = size-1
    [*0..last_elem_index].map {|i| list_generator.call(i)}
  end

  def cells_from_matrix(&index_generator)
    lists_from_matrix {|i| @matrix[i][index_generator.call(i)] }
  end

  def rows
    @matrix
  end

  def columns
    lists_from_matrix {|n| cells_from_matrix {|_| n} }
  end

  def diagonals
    main_diagonal = cells_from_matrix {|i| i}
    secondary_diagonal = cells_from_matrix {|i| size-i-1}
    [main_diagonal, secondary_diagonal]
  end

  def put(value, position)
    new_matrix = SquaredMatrix.new(@matrix.map{|l|l.clone})
    new_matrix.matrix[position[0]][position[1]] = value
    new_matrix
  end

  def all?(&condition)
    cells.all?{|cell|condition.call(cell)}
  end

  def positions
    cells.each_with_index.map do |_,i| i.divmod(size) end
  end

  def ==(other_matrix)
    matrix == other_matrix.matrix
  end


end