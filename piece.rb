# -*- coding: utf-8 -*-

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

    unless @board[hopped] == (@color == :white) ? :red : :white
      raise "no enemy piece to hop at #{hopped}"
    end

    move(new_pos)
    @board[hopped] = nil
  end

  def to_s
    s = " ◉ "
    if @color == :white
      s.colorize(:color => :white)
    else
      s.colorize(:color => :red)
    end
  end

  def direction(pos)
    row, col = pos
    [row -= @position[0], col -= @position[1]]
  end



  def hop_direction(pos)
    dir = direction(pos)
    [dir[0] / 2, dir[1] / 2 ]
  end

  private

  def move(new_pos)
    @board[new_pos] = self
    @board[@position] = nil
    self.position = new_pos
  end

  def assert_legal_end_pos(new_pos)
    unless new_pos.all?{|coord| (0..7).include?(coord) }
      raise "moved off the board"
    end
    raise "there is a piece in the way!" if @board[new_pos]

    nil
  end

  def assert_legal_direction(dir)
    unless dir.all?{|coord| coord.abs == 1}
      raise "tried to move to many squares"
    end

    unless (dir[0] + dir[1]).even?
      raise "did not move diagonally"
    end

    unless king
      if wrong_way?(dir[0])
        raise "pawns can't move in that direction"
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
