require 'rails_helper'
require_relative '../../spec/models/helper_methods'
RSpec.describe Player, type: :model do
  include TaTeTiHelperMethods

  let(:ia_player) {IAPlayer.create}
  let(:player1) {RealPlayer.create}
  let(:player2) {RealPlayer.create}
  let(:tateti) {TaTeTi.create(plays: [])}

  before :each do
    ia_player
    Game.create(ta_te_ti: tateti, player1: player1, player2: player2)
    tateti.init
  end

  it 'should be recovered correctly from the db' do
    expect(Player.first).to eq ia_player
  end

  it 'should be recovered correctly if I ask for its type' do
    expect(IAPlayer.first).to eq ia_player
  end

  it 'should not be recovered if I ask for a wrong type' do
    expect(RealPlayer.first).to_not eq ia_player
  end

  it 'should modify the game if it plays' do
    player1.put_play_in(tateti, [1, 1])
    expect(tateti.board).to eq (to_board([nil, nil, nil],
                                         [nil, :X, nil],
                                         [nil, nil, nil]))
  end

  it 'should tell the game to play_in some position if it is its active turn' do
    expect(tateti).to receive(:be_played).exactly(1).times
    allow(player1).to receive(:decide_position) { [0,0] }
    player1.play_turn(tateti)
  end

  describe IAPlayer do

    let(:player_bot) {IAPlayer.create}

    def position_should_be(position, player1, game)
      expect(player1.decide_position(game)).to eq position
    end

    it 'should choose an available position from the board to put its symbol on' do
      expect(tateti.available_positions.include? player_bot.decide_position(tateti)).to be true
    end

    it 'if possible, should choose a position that makes it win' do
      ta_te_ti = TaTeTi.new_ta_te_ti(plays: plays([1,0],[0,0],[1,1],[0,1]), player1: player_bot)
      position_should_be [1,2], player_bot, ta_te_ti
    end

    it 'should not have a possible position if the game is over' do
      position_should_be nil, player_bot,
                         TaTeTi.new_ta_te_ti(plays:plays([1,1],[0,1],[1,0],[0,0],[2,0],[1,2],[2,1],[0,2],[2,2]), player1: player_bot)
    end

    it 'if can not win, if possible it should choose a position that makes it not lose' do
      ta_te_ti = TaTeTi.new_ta_te_ti(plays: plays([1,0],[0,0],[2,2],[0,1]),player1:player_bot,player2:player2)
      position_should_be [0,2], player_bot, ta_te_ti
    end


    it 'A game between 2 IAs should be a tie' do
      player_bot2 = IAPlayer.create
      a_tateti = TaTeTi.new_ta_te_ti(plays: [], player1: player_bot, player2: player_bot2)
      while !a_tateti.game_over?
        begin
          player_bot.play_turn(a_tateti)
          player_bot2.play_turn(a_tateti)
        rescue GameAlreadyOverException
          a_tateti
        end
      end
      expect(a_tateti.tie?).to be true
    end

  end

end
