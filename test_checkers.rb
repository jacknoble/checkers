require_relative "checkerboard"


if $PROGRAM_NAME == __FILE__

  b = CheckerBoard.new

  white = b[[5,0]]

  red = b[[2,1]]

  red.slide([3,2])
  white.slide([4,1])
  red.hop([5,0])

  puts b

end