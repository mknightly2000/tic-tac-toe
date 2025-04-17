require "ruby2d"

class Game
    @@max_player = "X"
    @@min_player = "O"

    # main functions
    def initialize(grid_width, grid_height)
        @grid_width = grid_width # number of cells horizontally
        @grid_height = grid_height # number of cells vertically
        @board = Array.new(@grid_height) { Array.new(@grid_width) }

        # visuals
        @background_color = "#000000"
        @s = 100
        @padding_around_sign = 10
        @grid_line_width = 3
        @sign_line_width = 3

        # window
        @window_title = "Tic Tac Toe"
        @window_width = @grid_width * 100
        @window_height = @grid_height * 100
    end

    def print_board
        (0...@grid_height).each do |row|
            (0...@grid_width).each do |col|
                if @board[row][col].nil?
                    print "   "
                else
                    print " #{@board[row][col]} "
                end
                print "|" if col != @grid_width - 1
            end
            print "\n"
            puts "-" * (@grid_width * 3 + (@grid_width - 1)) if row != @grid_height - 1
        end
    end

    def make_move(move, player)
        x = move[0]
        y = move[1]

        if @board[x][y].nil?
            @board[x][y] = player
            true
        end
        false
    end

    def undo_move(move)
        x = move[0]
        y = move[1]
        unless @board[x][y].nil?
            @board[x][y] = nil
            true
        end
        false
    end

    def get_winner
        # Returns the winner if there is one, returns "draw" if board is full, otherwise return nil

        # check for horizontal win
        @board.each do |row|
            player = row[0]
            if row.all? { |cell| cell == player }
                return player
            end
        end

        # check for vertical win
        (0...@grid_width).each do |col|
            player = @board[0][col]
            if (0...@grid_height).all? { |row| @board[row][col] == player }
                return player
            end
        end

        # check for diagonal win only if grid is square
        if @grid_width == @grid_height
            l = @grid_width

            # main diagonal (top-left to bottom-right)
            player = @board[0][0]
            if (0...l).all? { |i| @board[i][i] == player }
                return player
            end

            # anti-diagonal (top-right to bottom-left)
            player = @board[0][l - 1]
            if (0...l).all? { |i| @board[i][l - 1 - i] == player }
                return player
            end
        end

        # check for draw
        return "draw" if @board.flatten.all? { |cell| cell != nil }

        # if no winner nor draw return nil
        nil
    end

    def get_opponent(player)
        return "O" if player == "X"
        "X" if player == "O"
    end

    # ai functions
    def minimax(depth, player)
        winner = get_winner

        # base cases
        return 1 if winner == "X"
        return -1 if winner == "O"
        return 0 if winner == "draw"

        # recursion
        if player == @@max_player
            best_score = -Float::INFINITY
        else
            best_score = Float::INFINITY
        end

        (0...@grid_height).each do |row|
            (0...@grid_width).each do |col|
                if @board[row][col].nil?
                    move = [row, col]
                    self.make_move(move, player)
                    new_score = self.minimax(depth + 1, get_opponent(player))
                    self.undo_move(move)
                    best_score = player == @@max_player ? [best_score, new_score].max : [best_score, new_score].min
                end
            end
        end

        best_score
    end

    def get_best_move_for(player)
        best_move = [] # a move is represented by a pair of coordinates [x, y]

        if player == @@max_player
            best_score = -Float::INFINITY
        else
            best_score = Float::INFINITY
        end

        (0...@grid_height).each do |row|
            (0...@grid_width).each do |col|
                if @board[row][col].nil?
                    move = [row, col]
                    self.make_move(move, player)
                    score = self.minimax(0, get_opponent(player))
                    self.undo_move(move)

                    if (player == @@max_player && score > best_score) || (player == @@min_player && score < best_score)
                        best_score = score
                        best_move = move
                    end
                end
            end
        end

        best_move
    end

    # visuals
    def draw_grid_line(order, is_vertical)
        if is_vertical
            Line.new(x1: order * @s, y1: 0, x2: order * @s, y2: @grid_height * @s, width: @grid_line_width, color: "black")
        else
            Line.new(x1: 0, y1: order * @s, x2: @grid_width * @s, y2: order * @s, width: @sign_line_width, color: "black")
        end
    end

    def create_grid
        (1...@grid_width).each do |i|
            draw_grid_line(i, true)
        end

        (1...@grid_height).each do |i|
            draw_grid_line(i, false)
        end
    end

    def draw_x(row, col)
        x = col * @s + @padding_around_sign
        y = row * @s + @padding_around_sign

        sign_size = @s - 2 * @padding_around_sign
        Line.new(x1: x, y1: y, x2: x + sign_size, y2: y + sign_size, width: 10, color: "red")
        Line.new(x1: x + sign_size, y1: y, x2: x, y2: y + sign_size, width: 10, color: "red")
    end

    def draw_o(row, col)
        x = col * @s + (@s / 2)
        y = row * @s + (@s / 2)
        Circle.new(x: x, y: y, radius: @s / 2 - @padding_around_sign, sectors: 64, color: "blue")
        Circle.new(x: x, y: y, radius: @s / 2 - @padding_around_sign - @sign_line_width, sectors: 64, color: @background_color)
    end

end

# main
game = Game.new(3, 3)
game.make_move([0, 0], "X")
game.make_move([1, 1], "O")
game.make_move([2, 0], "X")
game.make_move(game.get_best_move_for("O"), "O")
game.make_move([1, 2], "X")
game.print_board
game.make_move(game.get_best_move_for("O"), "O")
game.make_move(game.get_best_move_for("X"), "X")
game.make_move(game.get_best_move_for("O"), "O")
game.print_board



# visuals
# game.create_grid
# set title: "hello", width: 300, height: 300
# set background: "#000000"
# show
