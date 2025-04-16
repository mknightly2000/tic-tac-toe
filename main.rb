require "ruby2d"

set title: "Tic Tac Toe", width: 300, height: 300

# constants
$background_color = ""#000000""
$s = 100  # square_side_length
$padding_around_sign = 10
$sign_width = 3

set background: $background_color

# grid lines
Line.new(x1: $s, y1: 0, x2: $s, y2: 3 * $s, width: $sign_width, color: "black")
Line.new(x1: 2 * $s, y1: 0, x2: 2 * $s, y2: 3 * $s, width: $sign_width, color: "black")
Line.new(x1: 0, y1: $s, x2: 3 * $s, y2: $s, width: $sign_width, color: "black")
Line.new(x1: 0, y1: 2 * $s, x2: 3 * $s, y2: 2 * $s, width: $sign_width, color: "black")

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
  Circle.new(x: x, y: y, radius: $s / 2 - $padding_around_sign - $sign_width, sectors: 64, color: $background_color)
end



show