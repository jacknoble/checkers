require_relative "checkerboard"

class Game

  ALPHA_MOVES = ["a", "b", "c", "d", "e", "f", "g", "h"]

  def initialize
    @board = CheckerBoard.starting_board
    @turn = :white
  end

  def play
    until @board.over?
      turns
    end

    if @board.lost?(:red)
      "Congrats White, you win!!"
    else
      "Congrats Red, you win!!"
    end
  end

  def turns
    begin
      puts @board
      puts "#{@turn.capitalize}'s turn."
      puts "Which piece?"
      piece_to_move = @board[pos_parse(gets.chomp)]
      p piece_to_move.position
      puts "Enter move sequence: "
      seq = seq_parse(gets.chomp)
      p seq
      piece_to_move.perform_moves(seq)
    rescue InvalidMoveError
      retry
    else
      @turn = (@turn == :white) ? :red : :white
    end
  end

  def pos_parse(pos_string)
    pos_arr = pos_string.split("")
    col = ALPHA_MOVES.index(pos_arr[0])
    row = (8 - pos_arr[1].to_i)
    [row, col]
  end


  def seq_parse(seq_string)
    seq_arr = seq_string.split("-")
    seq_arr.map{|move| pos_parse(move)}
  end

end