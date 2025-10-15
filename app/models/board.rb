class Board < ApplicationRecord
  serialize :state, type: Array, coder: JSON

  after_initialize :init_board

  def init_board
    if self.state.nil? || self.state.empty?
      self.state = Array.new(3) { Array.new(3) }
    end
  end

  def place_symbol(x, y, symbol)
    return false unless valid_move?(x, y)
    self.state[x][y] = symbol
    save
  end

  def valid_move?(x, y)
    x.between?(0, 2) && y.between?(0, 2) && state[x][y].nil?
  end

  def full?
    state.flatten.none?(&:nil?)
  end

  def winner
    # Filas
    state.each do |row|
      return row[0] if row.uniq.size == 1 && row[0]
    end

    # Columnas
    (0..2).each do |i|
      col = [state[0][i], state[1][i], state[2][i]]
      return col[0] if col.uniq.size == 1 && col[0]
    end

    # Diagonales
    diag1 = [state[0][0], state[1][1], state[2][2]]
    diag2 = [state[0][2], state[1][1], state[2][0]]
    return diag1[0] if diag1.uniq.size == 1 && diag1[0]
    return diag2[0] if diag2.uniq.size == 1 && diag2[0]

    nil
  end

  # ======================================================
  # ================== LÓGICA MINIMAX  ===================
  # ======================================================

  def find_best_move(ai_symbol)
    player_symbol = (ai_symbol == 'X') ? 'O' : 'X'
    best_score = -Float::INFINITY
    best_move = nil

    # La IA opera sobre una copia del estado para no modificar el tablero real
    board_copy = self.state.map(&:clone)

    (0..2).each do |i|
      (0..2).each do |j|
        if board_copy[i][j].nil?
          # Realiza un movimiento hipotético en la copia
          board_copy[i][j] = ai_symbol
          
          # Llama a minimax para evaluar el movimiento
          score = minimax(board_copy, 0, false, ai_symbol, player_symbol)
          
          # Deshace el movimiento en la copia
          board_copy[i][j] = nil

          if score > best_score
            best_score = score
            best_move = [i, j]
          end
        end
      end
    end

    best_move
  end

  private 

  def minimax(current_board, depth, is_maximizing, ai_symbol, player_symbol)
    # Evalúa el tablero para ver si hay un ganador o un empate (caso base)
    score = evaluate_board(current_board, ai_symbol, player_symbol)

    # Si hay un ganador, devuelve la puntuación ajustada por la profundidad.
    # Esto hace que la IA prefiera una victoria más rápida.
    return score - depth if score == 10
    return score + depth if score == -10

    # Si el tablero está lleno (empate), la puntuación es 0.
    return 0 if board_full?(current_board)

    # Turno del Maximizador (IA)
    if is_maximizing
      best = -Float::INFINITY
      (0..2).each do |i|
        (0..2).each do |j|
          if current_board[i][j].nil?
            current_board[i][j] = ai_symbol
            best = [best, minimax(current_board, depth + 1, false, ai_symbol, player_symbol)].max
            current_board[i][j] = nil
          end
        end
      end
      return best
    # Turno del Minimizador (Jugador)
    else
      best = Float::INFINITY
      (0..2).each do |i|
        (0..2).each do |j|
          if current_board[i][j].nil?
            current_board[i][j] = player_symbol
            best = [best, minimax(current_board, depth + 1, true, ai_symbol, player_symbol)].min
            current_board[i][j] = nil
          end
        end
      end
      return best
    end
  end

  # Función de evaluación robusta que SIEMPRE devuelve un número.
  def evaluate_board(board, ai_symbol, player_symbol)
    lines = [
      # Filas
      [board[0][0], board[0][1], board[0][2]],
      [board[1][0], board[1][1], board[1][2]],
      [board[2][0], board[2][1], board[2][2]],
      # Columnas
      [board[0][0], board[1][0], board[2][0]],
      [board[0][1], board[1][1], board[2][1]],
      [board[0][2], board[1][2], board[2][2]],
      # Diagonales
      [board[0][0], board[1][1], board[2][2]],
      [board[0][2], board[1][1], board[2][0]]
    ]

    lines.each do |line|
      next if line.any?(&:nil?)
      if line.uniq.size == 1
        return 10 if line[0] == ai_symbol
        return -10 if line[0] == player_symbol
      end
    end

    # Si no hay ganador, la puntuación es 0 (caso neutro).
    # Esta línea es la que previene el error 'nil'.
    return 0
  end

  # Helper que funciona con cualquier estado del tablero (no solo self.state)
  def board_full?(board)
    board.flatten.none?(&:nil?)
  end
end