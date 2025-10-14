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
end
