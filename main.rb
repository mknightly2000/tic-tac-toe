require "ruby2d"

class Game
    @@max_player = "X"
    @@min_player = "O"
    @@player_to_play_first = "X"

    # variables
    # move: is represented by a pair of coordinates [x, y]
    # cell: is represented by a pair of coordinates [x, y]
    # player: either "X" or "O"
    # sign: either "X" or "O"

    # main functions
    def initialize(grid_width, grid_height, x_player_type, o_player_type)
        @grid_width = grid_width # number of cells horizontally
        @grid_height = grid_height # number of cells vertically
        @board = Array.new(@grid_height) { Array.new(@grid_width) }

        # game configuration
        @game_running = true
        @current_player = @@player_to_play_first
        @players_types = { # a type can either be "computer" or "human"
                           "X" => x_player_type,
                           "O" => o_player_type
        }

        # visuals
        @background_color = "#f8f7f6"
        @cell_side_length = 100
        @padding_around_sign = 20
        @grid_line_width = 3
        @sign_line_width = 7
        @x_color = "#008080"
        @o_color = "#FF7F50"

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

    # AI functions
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
        best_move = []

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

    # game management
    def is_running?
        @game_running
    end

    def current_player
        @current_player
    end

    def current_player_type
        @players_types[@current_player]
    end

    def side_width
        @cell_side_length
    end

    def finish_turn
        @current_player = get_opponent(@current_player)
    end

    def sign_at(cell)
        @board[cell[0]][cell[1]]
    end

    def finish_game
        @game_running = false
    end

    def execute(event = nil)
        if self.is_running?
            current_player = self.current_player
            current_player_type = self.current_player_type

            if current_player_type == "human"
                click_row = event.y / self.side_width
                click_col = event.x / self.side_width
                move = [click_row, click_col]
            else
                move = self.get_best_move_for(current_player)
            end

            if self.sign_at(move).nil?
                self.make_move(move, current_player)
                self.draw_sign(current_player, move)
                self.finish_turn
            end

            winner = self.get_winner
            unless winner.nil?
                self.finish_game
                if winner == "draw"
                    puts "Draw"
                else
                    puts "#{winner} won the match!"
                end
            end
        end
    end

    # visuals
    def draw_grid_line(order, is_vertical)
        if is_vertical
            Line.new(x1: order * @cell_side_length, y1: 0, x2: order * @cell_side_length, y2: @grid_height * @cell_side_length, width: @grid_line_width, color: "black")
        else
            Line.new(x1: 0, y1: order * @cell_side_length, x2: @grid_width * @cell_side_length, y2: order * @cell_side_length, width: @grid_line_width, color: "black")
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

    def draw_sign(sign, move)
        row = move[0]
        col = move[1]

        if sign == "X"
            x = col * @cell_side_length + @padding_around_sign
            y = row * @cell_side_length + @padding_around_sign

            sign_size = @cell_side_length - 2 * @padding_around_sign
            Line.new(x1: x, y1: y, x2: x + sign_size, y2: y + sign_size, width: @sign_line_width, color: @x_color)
            Line.new(x1: x + sign_size, y1: y, x2: x, y2: y + sign_size, width: @sign_line_width, color: @x_color)
        else
            x = col * @cell_side_length + (@cell_side_length / 2)
            y = row * @cell_side_length + (@cell_side_length / 2)
            Circle.new(x: x, y: y, radius: @cell_side_length / 2 - @padding_around_sign, sectors: 128, color: @o_color)
            Circle.new(x: x, y: y, radius: @cell_side_length / 2 - @padding_around_sign - @sign_line_width, sectors: 128, color: @background_color)
        end
    end
end

# main
game = Game.new(3, 3, "human", "computer")
game.create_grid

set title: "Tic Tac Toe", width: 300, height: 300
set background: "#f8f7f6"

on :mouse_down do |event|
    if game.current_player_type == "human"
        game.execute(event)
    end
end

tick = 0
update do
    if tick % 60 == 0
        if game.current_player_type == "computer"
            game.execute
        end
    end
    tick += 1
end

show