require "ruby2d"

$window_width = 300
$window_height = 300
$background_color = "#F6F1EC"
$x_color = "#008080"
$o_color = "#FF7F50"

set title: "Tic Tac Toe", width: $window_width, height: $window_height
set background: $background_color

# Represents a Tic-Tac-Toe game.
#
# This class manages the game state, including the board, players, and game logic.
# It also handles the visual representation using Ruby2D.
class Game
    @@max_player = "X"
    @@min_player = "O"
    @@player_to_play_first = "X"

    # variables
    # move: is represented by a pair of coordinates [x, y]
    # cell: is represented by a pair of coordinates [x, y]
    # player: either "X" or "O"
    # mark: either "X" or "O"

    attr_reader :current_player
    attr_reader :cell_side_length
    attr_reader :visual_objects # list of all the ui objects in Game

    # Initializes a new game of Tic-Tac-Toe.
    #
    # @param grid_width [Integer] The number of cells horizontally.
    # @param grid_height [Integer] The number of cells vertically.
    # @param x_player_type [String] Indicates if player X is "human" or "computer".
    # @param o_player_type [String] Indicates if player O is "human" or "computer".
    def initialize(grid_width, grid_height, x_player_type, o_player_type)
        @grid_width = grid_width
        @grid_height = grid_height
        @board = Array.new(@grid_height) { Array.new(@grid_width) }
        @game_running = true
        @current_player = @@player_to_play_first
        @players_types = { "X" => x_player_type, "O" => o_player_type }
        @visual_objects = []

        # Visual settings
        @cell_side_length = 100
        @padding_around_mark = 27 # by changing the padding, the mark's size changes
        @grid_line_width = 3
        @mark_line_width = 7
        @grid_line_color = "#CACBCA"

        self.create_grid
    end

    # Prints the current state of the board on the console (used for debugging)
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

    # Registers a move in the board 2d array
    #
    # @param move [Array<Integer>] an array of two integers [row, column] specifying the position on the board.
    # @param player [String] the player's mark to be placed on the board, either "X" or "O".
    # @return [Boolean] true if the position was empty and the mark was placed, false if the position was already occupied.
    def make_move(move, player)
        x, y = move
        if @board[x][y].nil?
            @board[x][y] = player
            true
        else
            false
        end
    end

    # Undoes a move by nullifying its cell in the board 2d array.
    #
    # @param move [Array<Integer>] an array of two integers [row, column] specifying the position on the board.
    def undo_move(move)
        x, y = move
        @board[x][y] = nil unless @board[x][y].nil?
    end

    # Determines the winner of the game or if it's a draw.
    #
    # This method checks the game board for a winner by examining rows, columns, and
    # diagonals (for square grids). If a winner is found, it returns the player's mark.
    # If the board is full and no winner is found, it returns "draw". If the game is
    # still ongoing, it returns nil.
    #
    # @return [String, nil] The winner's mark (a string) if there is a winner,
    #                              "draw" if the board is full with no winner,
    #                              or nil if the game is still ongoing.
    #
    # @note Diagonal checks are only performed if the grid is square
    #       (@grid_width == @grid_height).
    def get_winner
        # Check rows
        @board.each do |row|
            player = row[0]
            return player if row.all? { |cell| cell == player }
        end

        # Check columns
        (0...@grid_width).each do |col|
            player = @board[0][col]
            return player if (0...@grid_height).all? { |row| @board[row][col] == player }
        end

        # Check diagonals (for square grids only)
        if @grid_width == @grid_height
            l = @grid_width

            # main diagonal (top-left to bottom-right)
            player = @board[0][0]
            return player if (0...l).all? { |i| @board[i][i] == player }

            # anti-diagonal (top-right to bottom-left)
            player = @board[0][l - 1]
            return player if (0...l).all? { |i| @board[i][l - 1 - i] == player }
        end

        # Check for draw
        return "draw" if @board.flatten.all?
        nil
    end

    # Returns the opponent's mark.
    #
    # @param player [String] The current player's mark, either "X" or "O".
    # @return [String] The opponent's mark.
    def get_opponent(player)
        player == "X" ? "O" : "X"
    end

    # Implements the minimax algorithm to evaluate the board for the given player.
    #
    # @param depth [Integer] The current depth in the recursion.
    # @param player [String] The player for whom the board is being evaluated.
    # @return [Integer] The score of the board: 1 if X wins, -1 if O wins, 0 for a draw.
    def minimax(depth, player)
        winner = get_winner

        # Base Cases
        return 1 if winner == "X"
        return -1 if winner == "O"
        return 0 if winner == "draw"

        # Recursion
        best_score = player == @@max_player ? -Float::INFINITY : Float::INFINITY

        (0...@grid_height).each do |row|
            (0...@grid_width).each do |col|
                if @board[row][col].nil?
                    move = [row, col]
                    make_move(move, player)
                    score = minimax(depth + 1, get_opponent(player))
                    undo_move(move)
                    best_score = player == @@max_player ? [best_score, score].max : [best_score, score].min
                end
            end
        end
        best_score.to_i
    end

    # Determines the best move for the given player using the minimax algorithm.
    #
    # @param player [String] The player for whom to find the best move.
    # @return [Array<Integer>] The best move as an array of [row, column].
    def get_best_move_for(player)
        best_move = []
        best_score = player == @@max_player ? -Float::INFINITY : Float::INFINITY
        (0...@grid_height).each do |row|
            (0...@grid_width).each do |col|
                if @board[row][col].nil?
                    move = [row, col]
                    make_move(move, player)
                    score = minimax(0, get_opponent(player))
                    undo_move(move)
                    if (player == @@max_player && score > best_score) || (player == @@min_player && score < best_score)
                        best_score = score
                        best_move = move
                    end
                end
            end
        end
        best_move
    end

    # Checks if the game is still running.
    #
    # @return [Boolean] True if the game is running, false otherwise.
    def is_running?
        @game_running
    end

    # Returns the type of the current player.
    #
    # @return [String] The type of the current player, either "human" or "computer".
    def current_player_type
        @players_types[@current_player]
    end

    # Returns the mark at the specified cell.
    #
    # @param cell [Array<Integer>] An array containing the row and column indices of the cell.
    # @return [String, nil] The mark at the cell, either "X", "O", or nil if the cell isempty.
    def mark_at(cell)
        @board[cell[0]][cell[1]]
    end

    # Switches the current player to the opponent.
    def end_turn
        @current_player = get_opponent(@current_player)
    end

    # Ends the game by setting the game running state to false.
    def end_game
        @game_running = false
    end

    # Executes a turn in the game.
    #
    # @param event [Object, nil] The mouse event for human player's move, or nil for computer player.
    def execute_turn(event = nil)
        if is_running?
            if current_player_type == "human"
                click_row = event.y / @cell_side_length
                click_col = event.x / @cell_side_length
                move = [click_row, click_col]
            else
                move = self.get_best_move_for(current_player)
            end

            if mark_at(move).nil?
                self.make_move(move, current_player)
                self.draw_mark(current_player, move)
                self.end_turn
            end

            winner = self.get_winner
            unless winner.nil?
                self.end_game
                if winner == "draw"
                    puts "Draw"
                else
                    puts "Player #{winner} won the match!"
                end
            end
        end
    end

    # Draws a grid line on the screen.
    #
    # @param order [Integer] The order of the line (e.g., 1 for the first line).
    # @param is_vertical [Boolean] True if the line is vertical, false if horizontal.
    def draw_grid_line(order, is_vertical)
        line = if is_vertical
                   Line.new(x1: order * @cell_side_length, y1: 0, x2: order * @cell_side_length, y2: @grid_height * @cell_side_length, width: @grid_line_width, color: @grid_line_color)
               else
                   Line.new(x1: 0, y1: order * @cell_side_length, x2: @grid_width * @cell_side_length, y2: order * @cell_side_length, width: @grid_line_width, color: @grid_line_color)
               end
        @visual_objects << line
    end

    # Creates the visual grid for the game board.
    def create_grid
        (1...@grid_width).each { |i| draw_grid_line(i, true) }
        (1...@grid_height).each { |i| draw_grid_line(i, false) }
    end

    # Draws the player's mark on the board at the specified position.
    #
    # @param mark [String] The mark to draw, either "X" or "O".
    # @param move [Array<Integer>] The position [row, column] where to draw the mark.
    def draw_mark(mark, move)
        row, col = move

        if mark == "X"
            x = col * @cell_side_length + @padding_around_mark
            y = row * @cell_side_length + @padding_around_mark

            mark_size = @cell_side_length - 2 * @padding_around_mark

            line1 = Line.new(x1: x, y1: y, x2: x + mark_size, y2: y + mark_size, width: @mark_line_width, color: $x_color)
            line2 = Line.new(x1: x + mark_size, y1: y, x2: x, y2: y + mark_size, width: @mark_line_width, color: $x_color)

            @visual_objects << line1 << line2
        else
            x = col * @cell_side_length + (@cell_side_length / 2)
            y = row * @cell_side_length + (@cell_side_length / 2)

            circle1 = Circle.new(x: x, y: y, radius: @cell_side_length / 2 - @padding_around_mark, sectors: 128, color: $o_color)
            circle2 = Circle.new(x: x, y: y, radius: @cell_side_length / 2 - @padding_around_mark - @mark_line_width, sectors: 128, color: $background_color)

            @visual_objects << circle1 << circle2
        end
    end

    # Removes the game objects from the screen.
    def remove_visuals
        @visual_objects.each(&:remove)
        @visual_objects.clear
    end
end

# State management variables
@t = Time.now
@state = "welcome"
@welcome_objects = []
@game = nil
@game_end_time = nil

# Creates the welcome screen with buttons to choose playing as X or O.
def create_welcome_screen
    l = 60 # button side length
    sp = 15 # padding distance between mark and rectangle edge
    ssw = 7 # mark stroke width
    dr = 10 # vertical distance between rectangles

    x = ($window_width - l) / 2 # x-coordinate for both rectangles
    y1 = ($window_height - (2 * l + dr)) / 2 # y-coordinate of rectangle 1 which is equal to the distance between each rectangle and window edge
    y2 = y1 + l + dr # y-coordinate of rectangle 2

    @btn1 = Rectangle.new(x: x, y: y1, width: l, height: l, color: '#008080')
    @welcome_objects << @btn1

    line1 = Line.new(x1: x + sp, y1: y1 + sp, x2: x + l - sp, y2: y1 + l - sp, width: ssw, color: "#FFFFFF")
    line2 = Line.new(x1: x + l - sp, y1: y1 + sp, x2: x + sp, y2: y1 + l - sp, width: ssw, color: "#FFFFFF")
    @welcome_objects << line1 << line2

    @btn2 = Rectangle.new(x: x, y: y2, width: l, height: l, color: '#FF7F50')
    @welcome_objects << @btn2

    r2_c_x = x + l / 2
    r2_x_y = y2 + l / 2
    circle1 = Circle.new(x: r2_c_x, y: r2_x_y, radius: l / 2 - sp + (ssw / 2), sectors: 128, color: "#FFFFFF")
    circle2 = Circle.new(x: r2_c_x, y: r2_x_y, radius: l / 2 - sp - (ssw / 2), sectors: 128, color: "#FF7F50")
    @welcome_objects << circle1 << circle2
end

# Removes the welcome screen objects from the screen.
def remove_welcome_screen
    @welcome_objects.each(&:remove)
    @welcome_objects.clear
end

# Creates the game screen and initializes a new game.
#
# @param player_choice [String] The player's choice, either "X" or "O", indicating which player is human.
def create_game_screen(player_choice)
    x_type = player_choice == "X" ? "human" : "computer"
    o_type = player_choice == "O" ? "human" : "computer"
    @game = Game.new(3, 3, x_type, o_type)
    @t = Time.now
end

# Removes the game screen objects and resets the game.
def remove_game_screen
    @game.remove_visuals
    @game = nil
end

# Initialize with welcome screen.
create_welcome_screen

# Handle user mouse clicks.
on :mouse_down do |event|
    if @state == "welcome"
        if @btn1.contains?(event.x, event.y)
            player_choice = "X"
        elsif @btn2.contains?(event.x, event.y)
            player_choice = "O"
        end

        if player_choice
            remove_welcome_screen
            create_game_screen(player_choice)
            @state = "game"
        end
    elsif @state == "game" && @game.current_player_type == "human"
        @game.execute_turn(event)
        @t = Time.now
    end
end

# The Update Loop
update do
    if @state == "game"
        if @game.current_player_type == "computer"
            if Time.now - @t > 0.5
                @game.execute_turn
            end
        end

        unless @game.is_running?
            if @game_end_time.nil?
                @game_end_time = Time.now
            elsif Time.now - @game_end_time > 2.0
                remove_game_screen
                create_welcome_screen
                @state = "welcome"
                @game_end_time = nil
            end
        end
    end
end

# Start the application
show