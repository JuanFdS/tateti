module TaTeTiHelperMethods

  def to_lines(*arrays)
    arrays.map{|array| Line.new(array)}
  end

  def to_board(*arrays)
    Board.new(SquaredMatrix.new(arrays))
  end

  def to_tateti_no_players(*arrays)
    ta_te_ti = TaTeTi.new_ta_te_ti
    ta_te_ti.board = to_board(*arrays)
    ta_te_ti
  end

  def empty_3x3_tateti
    TaTeTi.new(empty_3x3_board,nil,nil)
  end

  def empty_3x3_board
    Board.new_empty(3)
  end

  def plays(*positions)
    positions.each_with_index.map{|pos,index| index.even? ? Play.new(:X, pos) : Play.new(:O, pos) }
  end

end
