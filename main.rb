require 'ruby2d'

set title: "Tic Tac Toe", width: 300, height: 300

# grid lines
Line.new(x1: 100, y1: 0, x2: 100, y2: 300, width: 2, color: 'black')
Line.new(x1: 200, y1: 0, x2: 200, y2: 300, width: 2, color: 'black')
Line.new(x1: 0, y1: 100, x2: 300, y2: 100, width: 2, color: 'black')
Line.new(x1: 0, y1: 200, x2: 300, y2: 200, width: 2, color: 'black')

show