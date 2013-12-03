# -*- coding: utf-8 -*-

class InvalidMoveError < StandardError
end

require "colorize"

class Piece

  attr_accessor :position, :color, :king, :board

  def initialize(board, position, color)
    @board, @position, @color = board, position, color
    @king = false
  end


  def crown
    self.king = true
  end

  def king?
    @king
  end

  def perform_moves!(sequence)
    if sequence.count == 1
      if direction(sequence[0]).all?{|coord| coord.abs == 1}
        slide(sequence[0])
      else
        hop(sequence[0])
      end
    else
      sequence.each do |move|
        hop(move)
      end
    end
  end


  def perform_moves(seq)
    unless valid_move_seq?(seq)
      raise InvalidMoveError.new "invalid sequence"
    end

    perform_moves!(seq)
  end


  def slide(new_pos)
    assert_legal_direction(direction(new_pos))
    assert_legal_end_pos(new_pos)

    move(new_pos)
  end

  def hop(new_pos)
    direction = hop_direction(new_pos)
    assert_legal_direction(direction)
    assert_legal_end_pos(new_pos)

    hopped =[@position[0] + direction[0], @position[1] + direction[1]]
    puts @board[hopped]

    unless @board[hopped].color == ((@color == :white) ? :red : :white)
      raise InvalidMoveError.new "no enemy piece to hop there"
    end

    move(new_pos)
    @board[hopped] = nil
  end

  def to_s
    if king?
      s = "◎"
    else
      s = "◉"
    end
  end

  def valid_move_seq?(seq)
    begin
      test_board = @board.dup
      test_piece = test_board[@position]
      test_piece.perform_moves!(seq)
    rescue InvalidMoveError => e
      puts e.message
      false
    else
      true
    end
  end


  private


  def direction(pos)
    row, col = pos
    [row -= @position[0], col -= @position[1]]
  end

  def hop_direction(pos)
    dir = direction(pos)
    [dir[0] / 2, dir[1] / 2 ]
  end

  def move(new_pos)
    @board[new_pos] = self
    @board[@position] = nil
    self.position = new_pos
    self.crown if last_row?
  end

  def last_row?
    (@color == :white && @position[0] == 0) ||
    (@color == :red && @position[0] == 7)
  end


  def assert_legal_end_pos(new_pos)
    unless new_pos.all?{|coord| (0..7).include?(coord) }
      raise InvalidMoveError.new "moved off the board"
    end
    if @board[new_pos]
      raise InvalidMoveError.new "there is a piece in the way!"
    end

    nil
  end

  def assert_legal_direction(dir)
    unless dir.all?{|coord| coord.abs == 1}
      raise InvalidMoveError.new "tried to move too many squares"
    end

    unless (dir[0] + dir[1]).even?
      raise InvalidMoveError.new "did not move diagonally"
    end

    unless king
      if wrong_way?(dir[0])
        raise InvalidMoveError.new "pawns can't move in that direction"
      end
    end

    nil
  end

  def wrong_way?(vert_dir)
    if color == :red
      vert_dir == -1
    else
      vert_dir == 1
    end
  end


end
