require_relative "piece"
require "colorize"

class CheckerBoard

  attr_accessor :board_matrix

  def initialize(board_size = 8)
    @board_matrix = Array.new(board_size) { Array.new(board_size) }
  end

  def self.starting_board
    new_board = CheckerBoard.new
    new_board.set_pieces
    new_board
  end

  def [](pos)
    row, col = pos
    @board_matrix[row][col]
  end

  def []=(pos, assignment)
    row, col = pos
    @board_matrix[row][col] = assignment
  end

  def lost?(color)
    !piece_set.any?{|pc| pc.color == color}
  end

  def over?
    lost?(:red) || lost?(:white)
  end


  def to_s
    offset = 0
    display = self.dup
    display.board_matrix.each_with_index do |row, row_i|
      row.map! do |piece|
        offset += 1
        if piece.nil?
          disp_char = "   "
          if (row_i + offset).even?
            disp_char.colorize(:background => :black )
          else
            disp_char.colorize(:background => :green )
          end
        else
          disp_char = " " + piece.to_s + " "
          if (row_i + offset).even?
            disp_char.colorize(:color => piece.color, :background => :black )
          else
            disp_char.colorize(:color => piece.color, :background => :green )
          end
        end
      end
    end
    display.board_matrix << [" A ", " B ", " C ", " D ", " E ", " F ", " G ", " H "]
    display.board_matrix.each_with_index do |row, i|
      row << " #{8-i}"
    end
    display.board_matrix.map{|row| row.join("") }.join("\n")
  end

  def piece_set
    @board_matrix.flatten.select{|tile| !tile.nil?}
  end

  def dup
    dup_board = CheckerBoard.new
    piece_set.each do |pc|
      dup_board[pc.position] = Piece.new(dup_board, pc.position, pc.color )
    end

    dup_board

  end

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
