
class TaTeTiController < ActionController::Base

  def view
    hash = {X: 'X', O: 'O', nil => ' ' }
    id = params[:id]
    ta_te_ti = TaTeTi.find(id)
    board = [ta_te_ti.cells.take(3), ta_te_ti.cells.drop(3).take(3), ta_te_ti.cells.drop(6)].map{|row| row.map{ |sym| hash[sym]} }
    next_move = ta_te_ti.player_symbols[ta_te_ti.players[0]]
    render locals: {ta_te_ti: ta_te_ti,
                    players_and_symbols: ta_te_ti.player_symbols,
                    board: board, next_move: next_move,
                    positions: ta_te_ti.available_positions,
                    game_over: ta_te_ti.game_over?}
  end

  def list
    ta_te_tis = TaTeTi.all
    ta_te_tis = ta_te_tis.select{|ta_te_ti| ta_te_ti.game_over?} if params[:game_over] == 'true'
    ta_te_tis_ids = ta_te_tis.map{|ta_te_ti| ta_te_ti.id}
    render locals: {games_ids: ta_te_tis_ids }
  end

  def play
    ta_te_ti = TaTeTi.find(params[:id])
    position = eval(params[:pos])
    ta_te_ti.be_played(ta_te_ti.players[0], position)
    ta_te_ti.save
    redirect_to "/ta_te_tis/#{params[:id]}"
  end

  def new
    ta_te_ti = TaTeTi.new_ta_te_ti
    redirect_to "/ta_te_tis/#{ta_te_ti.id}"
  end

end