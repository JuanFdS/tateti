require_relative '../../app/models/exceptions'
require_relative '../../app/models/board'
require_relative '../../app/models/player'

class TaTeTi < ActiveRecord::Base
  has_one :game

  serialize :plays

  attr_accessor :board, :players, :player_symbols

  after_find :init

  def self.new_ta_te_ti(plays: [], player1: IAPlayer.create, player2: IAPlayer.create)
    ta_te_ti = TaTeTi.create(plays: plays)
    Game.create(ta_te_ti: ta_te_ti, player1: player1, player2: player2)
    TaTeTi.find(ta_te_ti.id)
  end

  def init
    @board = Board.new_empty 3
    @players = [game.player1, game.player2]
    @player_symbols = {players[0] => :X, players[1] => :O}
    plays.each {|play| self.next_move play}
  end

  def simulate_move(player, position)
    ta_te_ti = TaTeTi.new
    ta_te_ti.board = board
    ta_te_ti.players = players
    ta_te_ti.player_symbols = player_symbols
    ta_te_ti.put_players_play(player, position)
    ta_te_ti
  end

  def to_s
    "Juego #{id}:#{board.matrix.matrix}"
  end

  def symbol(player)
    @player_symbols[player]
  end

  def be_played(player, position)
    validate_play(player)
    place_move_and_end_turn!(Play.new(symbol(player), position))
  end

  def next_move(play)
    place_move_and_end_turn(play)
  end

  def place_move_and_end_turn!(play)
    put_play!(play)
    end_turn
  end

  def place_move_and_end_turn(play)
    put_play(play)
    end_turn
  end

  def end_turn
    @players = @players.reverse
  end

  def win?(sym = nil)
    board.all_lines.any? {|line| line.win?(sym)}
  end

  def tie?
    game_over? && !win?
  end

  def game_over?
    win? || board.full?
  end

  def available_positions
    return [] if game_over?
    board.available_positions
  end

  def get_positions(&condition)
    available_positions.select &condition
  end

  def current_player?(player)
    current_player == player
  end

  def opponent(player)
    players.find{|other_player| other_player != player}
  end

  def ==(other_game)
    board == other_game.board
  end

  def put_players_play(player, position)
    put_play(Play.new(symbol(player),position))
  end

  def put_play!(play)
    plays << play
    put_play(play)
  end

  def put_play(play)
    @board = board.put(play)
  end

  def cells
    board.cells
  end

  private
  def current_player
    players.first
  end

  def validate_play(player)
    raise GameAlreadyOverException if game_over?
    raise InvalidPlayerException unless current_player?(player)
  end

  def winner_symbol
    board.all_lines.find(&:win?).first
  end

end
