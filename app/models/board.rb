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
        state[x][y] = symbol
        save
    end

    def valid_move?(x, y)
        x.between?(0,2) && y.between?(0,2) && state[x][y].nil?
    end

    def full?
        state.flatten.none?(&:nil?)
    end

    def winner 
        #filas
        state.each do |row|
            return row[0] if row.all? && row.uniq.size == 1 && row[0]
        end

        #columnas 
        (0..2).each do |i|
            col = [state[0][i], state[1][i], state[2][i]]
            return col[0] if col.all? && col.uniq.size == 1 && col[0]
        end

        #diagonales

        diag1 = [state[0][0], state[1][1], state[2][2]]
        diag2 = [state[0][2], state[1][1], state[2][0]]
        return diag1[0] if diag1.all? && diag1.uniq.size == 1 && diag1[0]
        return diag2[0] if diag2.all? && diag2.uniq.size == 1 && diag2[0]
        nil
    end

    # minimax logica

    def find_best_move(ai_symbol)
        best_score = -Float::INFINITY
        best_move = nil
        player_symbol = (ai_symbol == 'X') ? 'O' : 'X'
        (0..2).each do |i|
            (0..2).each do |j|
                if self.state[i][j].nil? #si la casilla esta vacia
                    state[i][j] = ai_symbol #haga el movimiento hipotetico
                    score = minimax(self.state, 0, false, ai_symbol, player_symbol) #llamo a minimax
                    state[i][j] = nil # 'Deshace' el movimiento
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

    def minimax(current_state, depth, is_maxi, ai_symbol, player_symbol)
        score = evaluate(current_state, ai_symbol, player_symbol)
        return score - depth if score == 10
        return score + depth if score == -10
        return 0 if board_full?(current_state)

        if is_maxi
            best = -Float::INFINITY
            (0..2).each do |i|
                (0..2).each do |j|
                    if current_state[i][j].nil?
                        current_state[i][j] = ai_symbol
                        score = minimax(current_state, depth + 1, false, ai_symbol, player_symbol)
                        current_state[i][j] = nil
                        best_score = [score, best_score].max
                    end
                end
            end
            return best_score
        else #turno del jugador (minimiza el puntaje ia)
            best = Float::INFINITY
            (0..2).each do |i|
                (0..2).each do |j|
                    if current_state[i][j].nil?
                        current_state[i][j] = player_symbol
                        score = minimax(current_state, depth + 1, true, ai_symbol, player_symbol)
                        current_state[i][j] = nil
                        best_score = [score, best_score].min
                    end
                end
            end
            return best_score
        end
    end

    def evaluate(board_state, ai_symbol, player_symbol)
        #filas
        board_state.each do |row|
            if row.uniq.size == 1 && row[0]
                return 10 if row[0] == ai_symbol
                return -10 if row[0] == ai_symbol
            end
        end

        # Columnas
        (0..2).each do |i|
            col = [board_state[0][i], board_state[1][i], board_state[2][i]]
            if col.uniq.size == 1 && col[0]
                return 10 if col[0] == ai_symbol
                return -10 if col[0] == player_symbol
            end
        end


        # Diagonales
        diag1 = [board_state[0][0], board_state[1][1], board_state[2][2]]
        if diag1.uniq.size == 1 && diag1[0]
            return 10 if diag1[0] == ai_symbol
            return -10 if diag1[0] == player_symbol
        end

        diag2 = [board_state[0][2], board_state[1][1], board_state[2][0]]
        if diag2.uniq.size == 1 && diag2[0]
            return 10 if diag2[0] == ai_symbol
            return -10 if diag2[0] == player_symbol
        end

        # Si no hay ganador, la puntuación es 0
        return 0
    end

    # Un método auxiliar para verificar si un tablero (array) está lleno.
    def board_full?(board_state)
        board_state.flatten.none?(&:nil?)
    end
end
