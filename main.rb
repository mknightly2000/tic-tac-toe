require "ruby2d"

# constants
$background_color = "#000000"
$grid_width = 3 # number of cells horizontally
$grid_height = 3 # number of cells vertically
$s = 100 # length of cell side
$padding_around_sign = 10
$grid_line_width = 3
$sign_line_width = 3

# initialize game
set title: "Tic Tac Toe", width: 300, height: 300
set background: $background_color

board = Array.new($grid_height) { Array.new($grid_width) }

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

# misc funcs
def print_board(board)
    (0...$grid_height).each do |row|
        (0...$grid_width).each do |col|
            if board[row][col].nil?
                print "   "
            else
                print " #{board[row][col]} "
            end
            print "|" if col != $grid_width - 1
        end
        print "\n"
        puts "-" * ($grid_width * 3 + ($grid_width - 1)) if row != $grid_height - 1
    end
end

def make_move(x, y, player, board)
    if board[x][y].nil?
        board[x][y] = player
        true
    end
    false
end

# game end
def game_over?(board)
    height = board.length
    width = board[0].length

    # check for horizontal win
    board.each do |row|
        sign = row[0]
        if row.all? { |cell| cell == sign }
            return sign
        end
    end

    # check for vertical win
    (0...width).each do |col|
        sign = board[0][col]
        if (0...height).all? { |row| board[row][col] == sign }
            return sign
        end
    end

    # check for diagonal win only if grid is square
    if width == height
        l = width

        # main diagonal (top-left to bottom-right)
        sign = board[0][0]
        if (0...l).all? { |i| board[i][i] == sign }
            return sign
        end

        # anti-diagonal (top-right to bottom-left)
        sign = board[0][l - 1]
        if (0...l).all? { |i| board[i][l - 1 - i] == sign }
            return sign
        end
    end

    # check for draw
    return 'draw' if board.flatten.all? { |cell| cell != nil }

    # if no winner nor draw return nil
    nil
end

# ai player
$max_player = "X"
$min_player = "O"

def evaluate(board, winner = nil)
    if winner == nil
        winner = game_over?(board)
    end

    return 1 if winner == "X"
    return -1 if winner == "O"
    nil
end

def minimax(board, depth, player)
    result = game_over?(board)
    return evaluate(board, result) if result

    if player == $max_player
        best_score = -Float::INFINITY
    else
        best_score = Float::INFINITY
    end

    (0...$grid_height).each do |row|
        (0...$grid_width).each do |col|
            if board[row][col].nil?
                board[row][col] = player
                new_score = minimax(board, depth + 1, player)
                board[row][col] = nil
                best_score = player == $max_player ? [best_score, new_score].max : [best_score, new_score].min
            end
        end
    end

    best_score
end

# main
make_move(0, 2, $max_player, board)
print_board(board)
# create_grid
# show