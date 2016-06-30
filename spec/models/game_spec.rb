require 'rails_helper'

RSpec.describe Game, type: :model do

  before :each do
    player1 = RealPlayer.create(id: 1)
    player2 = RealPlayer.create(id: 2)
    ta_te_ti = TaTeTi.create(id:1, plays:[])
    Game.create(ta_te_ti: ta_te_ti, player1: player1, player2: player2)
  end

  it 'should recover the game correctly' do
    game = Game.first
    expect(game.player1).to eq Player.first
    expect(game.player2).to eq Player.second
    expect(game.ta_te_ti).to eq TaTeTi.first
  end

  it 'should be possible to find all the ta_te_tis that contain a certain player' do
    ta_te_ti = TaTeTi.create(id:2, plays:[])
    player1 = Player.find(1)
    Game.create(ta_te_ti:ta_te_ti, player1: player1, player2: Player.find(2) )
    expect(player1.ta_te_tis).to eq [TaTeTi.first, TaTeTi.second]
  end

  it 'should be possible to find all the players that played a ta_te_ti game' do
    expect(TaTeTi.first.players).to eq [Player.first, Player.second]
  end


end
