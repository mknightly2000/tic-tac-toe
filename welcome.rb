require "ruby2d"

window_width = 300
window_height = 300

set title: "Tic Tac Toe", width: 300, height: 300
set background: "#f6f1ec"

l = 60 # button side length
sp = 15  # padding distance between sign and rectangle edge
ssw = 7 # sign stroke width
dr = 10 # vertical distance between rectangles

x = (window_width - l) / 2 # x-coordinate for both rectangles
y1 = (window_height - (2 * l + dr)) / 2 # y-coordinate of rectangle 1 which is equal to the distance between each rectangle and window edge
y2 = y1 + l + dr # y-coordinate of rectangle 2

Rectangle.new(
    x: x, y: y1,
    width: l, height: l,
    color: '#008080'
)

Line.new(x1: x + sp, y1: y1 + sp, x2: x + l - sp, y2: y1 + l - sp, width: ssw, color: "#FFFFFF")
Line.new(x1: x + l - sp, y1: y1 + sp, x2: x + sp, y2: y1 + l - sp, width: ssw, color: "#FFFFFF")

Rectangle.new(
    x: x, y: y2,
    width: l, height: l,
    color: '#FF7F50'
)

r2_c_x = x + l / 2 # x-coordinate of rectangle 2's center
r2_x_y = y2 + l / 2 # y-coordinate of rectangle 2's center
Circle.new(x: r2_c_x, y: r2_x_y, radius: l / 2 - sp + (ssw / 2), sectors: 128, color: "#FFFFFF")
Circle.new(x: r2_c_x, y: r2_x_y, radius: l / 2 - sp - (ssw / 2), sectors: 128, color: "#FF7F50")

show