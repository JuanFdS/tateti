require 'rails_helper'
require_relative '../../app/models/player'
require_relative '../../spec/models/helper_methods'

RSpec.describe TaTeTi, type: :model do

  include TaTeTiHelperMethods

  it 'should be correctly retrieved from TaTeTi' do
    TaTeTi.new_ta_te_ti(plays: plays([1,2],[2,2],[0,0]))
    expect(TaTeTi.first.plays).to eq (plays([1,2],[2,2],[0,0]))
  end

  it 'should be constructed correctly' do
    TaTeTi.new_ta_te_ti(plays: plays([1,2],[2,2],[0,0]))
    expect(TaTeTi.first.board.matrix.matrix).to eq([[:X,  nil, nil],
                                                    [nil, nil, :X],
                                                    [nil, nil, :O]])
  end

  it 'should be work correctly after constructed' do
    TaTeTi.new_ta_te_ti(plays: plays([1,2],[2,2],[0,0],[2,1],[1,1],[2,0]))
    expect(TaTeTi.first.win?).to be true
  end

  describe Board do

    let(:board_1_9) {Board.new(SquaredMatrix.new([[1,2,3],
                                                  [4,5,6],
                                                  [7,8,9]]))}

    it 'should have the same amount of rows as its size' do
      expect(Board.new_empty(3).rows.size).to be 3
    end

    it 'should have the same amount of columns as its size' do
      expect(Board.new_empty(3).columns.size).to be 3
    end

    it 'the columns should be the rows flipped' do
      expect(board_1_9.columns).to eq (to_lines([1,4,7],
                                                [2,5,8],
                                                [3,6,9]))
    end

    it 'the columns should be the rows flipped' do
      expect(to_board([0,0,0],
                      [0,0,0],
                      [0,0,0]).columns).to eq (to_lines([0,0,0],
                                                        [0,0,0],
                                                        [0,0,0]))
    end

    it 'should have 2 diagonals' do
      expect(Board.new_empty(3).diagonals.size).to be 2
    end

    it 'the diagonals should be the diagonals of the board matrix' do
      expect(board_1_9.diagonals).to eq (to_lines([1,5,9],
                                                  [3,5,7]))
    end

    it 'a position should be available if it has nil on it' do
      expect(Board.new_empty(3).is_available([1,1])).to be true
    end

    it 'a position should not be available if it has something not nil on it' do
      expect(board_1_9.is_available([1,1])).to be false
    end

    it 'should modify the board if I put something into that position' do
      expect(Board.new_empty(3).put(Play.new(:X,[1,1]))).to eq (to_board([nil,nil,nil],
                                                               [nil,:X ,nil],
                                                               [nil,nil,nil]))
    end

    it 'should not allow me to put something in an invalid position' do
      expect{Board.new_empty(3).put(Play.new(:X,[5,15]))}.to raise_exception OutOfBoardException
    end

    it 'should not allow me to put something in an occupied position' do
      expect{board_1_9.put(Play.new(5,[2,2])).is_available([2,2])}.to raise_exception OccupiedPositionException
    end

  end

  describe TaTeTi do

    it 'should be a win if any row has all O or Xs' do
      expect(to_tateti_no_players([:X, :X, :X],
                                  [nil,  :O,   :O],
                                  [nil,  nil,  nil]).win?).to be true
    end

    it 'should be a win if any column has all O or Xs' do
      expect(to_tateti_no_players([:X, nil, :X],
                                  [:X,   :O,   :O],
                                  [:X,   nil,  nil]).win?).to be true
    end

    it 'should be a win if any diagonal has all O or Xs' do
      expect(to_tateti_no_players([:X, nil, :O],
                                  [:X,   :O,   :O],
                                  [:O,   nil,  nil]).win?).to be true
    end

    it 'game should be over if it is a win' do
      expect(to_tateti_no_players([:X, nil, :X],
                                  [:X,   :O,   :O],
                                  [:X,   nil,  nil]).game_over?).to be true
    end

    it 'game should be over if the board is full' do
      expect(to_tateti_no_players([:X, :O, :X],
                                  [:X,   :O,   :X],
                                  [:O,   :X,  :O]).game_over?).to be true
    end

    it 'should not be possible to play if the game is over' do
      expect{to_tateti_no_players([:X, nil, :X],
                                  [:X,   :O,   :O],
                                  [:X,   nil,  nil]).be_played(:X, [1, 1])}.to raise_exception GameAlreadyOverException
    end

  end

end
