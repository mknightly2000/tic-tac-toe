require "ruby2d"

# constants
$background_color = "#000000"
$grid_width = 3 # number of cells horizontally
$grid_height = 3 # number of cells vertically
$s = 100 # length of cell side
$padding_around_sign = 10
$grid_line_width = 3
$sign_line_width = 3

# initialize canvas
set title: "Tic Tac Toe", width: 300, height: 300
set background: $background_color

# grid lines
def draw_grid_line(order, is_vertical)
  if is_vertical
    Line.new(x1: order * $s, y1: 0, x2: order * $s, y2: $grid_height * $s, width: $grid_line_width, color: "black")
  else
    Line.new(x1: 0, y1: order * $s, x2: $grid_width * $s, y2: order * $s, width: $sign_line_width, color: "black")
  end
end

def create_grid
  (1...$grid_width).each do |i|
    draw_grid_line(i, true)
  end

  (1...$grid_height).each do |i|
    draw_grid_line(i, false)
  end
end

# Xs and Os
def draw_x(row, col)
  x = col * $s + $padding_around_sign
  y = row * $s + $padding_around_sign

  sign_size = $s - 2 * $padding_around_sign
  Line.new(x1: x, y1: y, x2: x + sign_size, y2: y + sign_size, width: 10, color: "red")
  Line.new(x1: x + sign_size, y1: y, x2: x, y2: y + sign_size, width: 10, color: "red")
end

def draw_o(row, col)
  x = col * $s + ($s / 2)
  y = row * $s + ($s / 2)
  Circle.new(x: x, y: y, radius: $s / 2 - $padding_around_sign, sectors: 64, color: "blue")
  Circle.new(x: x, y: y, radius: $s / 2 - $padding_around_sign - $sign_line_width, sectors: 64, color: $background_color)
end

create_grid
show