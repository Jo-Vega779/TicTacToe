# app/controllers/games_controller.rb
class GamesController < ApplicationController
  before_action :set_game, only: [:show, :move]

  # Muestra la lista de juegos terminados (historial)
  def index
    @games = Game.where.not(status: "ongoing").order(updated_at: :desc)
  end

  # Muestra el formulario para crear un nuevo juego (app/views/games/new.html.erb)
  def new
    # Ahora esta acción simplemente renderiza la vista del formulario.
  end

  # Crea el juego con los nombres de los jugadores del formulario
  def create
    # Busca el jugador por nombre, si no existe, lo crea.
    player_x = Player.find_or_create_by(name: params[:player_x_name])
    player_o = Player.find_or_create_by(name: params[:player_o_name])
    
    board = Board.create
    @game = Game.create(
      player_x: player_x,
      player_o: player_o,
      board: board,
      status: "ongoing"
    )

    redirect_to @game
  end

  def show
    @board = @game.board
  end

  def move
    x, y = params[:x].to_i, params[:y].to_i
    current_symbol = @game.current_turn_symbol

    if @game.board.place_symbol(x, y, current_symbol)
      check_game_status
    end

    redirect_to @game
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def check_game_status
    winner_symbol = @game.board.winner
    if winner_symbol
      winner = winner_symbol == "X" ? @game.player_x : @game.player_o
      @game.update(status: "Winner: #{winner.name} (#{winner_symbol})")
    elsif @game.board.full?
      @game.update(status: "Draw")
    end
  end
end