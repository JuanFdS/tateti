require_relative '../../app/models/play'

class Player < ActiveRecord::Base
    has_many :games
    has_many :ta_te_tis, through: :games

    def ta_te_tis
      TaTeTi.select{|ta_te_ti| ta_te_ti.players.include? self }
    end

    def put_play_in(game, position)
      game.be_played(self, position)
    end

    def is_winning_position?(game, position)
      game.simulate_move(self, position).win?
    end

    def is_assured_win_position?(game, position)
      is_assured_win?(game.simulate_move(self, position))
    end

    def is_assured_win?(game)
      (!game.available_positions.any?{|pos|is_losing_position?(game,pos)}) &&
          game.available_positions.count{|pos|is_winning_position?(game, pos)} >= 2
    end

    def is_losing_position?(game, position)
      game.opponent(self).is_winning_position?(game, position)
    end

    def is_assured_loss_position?(game, position)
      game.opponent(self).is_assured_win_position?(game, position)
    end

    def play_turn(game)
      put_play_in(game, decide_position(game))
    end

    def ==(other_player)
      id == other_player.id
    end

end

class IAPlayer < Player

  def decide_position(game)
    (game.get_positions{|pos| is_winning_position?(game, pos)} +
        game.get_positions{|pos| is_losing_position?(game, pos)} +
        game.get_positions{|pos| is_assured_win_position?(game, pos)} +
        game.get_positions{|pos| is_assured_loss_position?(game, pos)} +
        game.available_positions).first
  end

  def positions_that(game, &condition)
    game.get_positions &condition
  end


end

class RealPlayer < Player

  def decide_position(_)

  end

end
