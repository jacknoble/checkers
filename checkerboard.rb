require_relative "piece"

class CheckerBoard

  attr_accessor :board_matrix

  def initialize(board_size = 8)
    @board_matrix = Array.new(board_size) { Array.new(board_size) }
    set_pieces
  end

  def [](pos)
    row, col = pos
    @board_matrix[row][col]
  end

  def []=(pos, assignment)
    row, col = pos
    @board_matrix[row][col] = assignment
  end

  def to_s
    @board_matrix.map { |row| row.to_s }.join("\n")
  end


  private

    COLOR_START = {:red => (0..2), :white => (5..7)}

    def set_pieces
      COLOR_START.each_pair do |color, range|
        @board_matrix[range].each_with_index do |row, row_i|
          row.each_index do |col_i|
            new_i = (color == :white) ? row_i + 5 : row_i
            if (new_i + col_i).odd?
              row[col_i] = Piece.new(self,[new_i, col_i], color)
            end
          end
        end
      end

    end




end
