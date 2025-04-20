require 'glimmer-dsl-swt'
include Glimmer

class GUI
    include Glimmer::UI::CustomShell

    @@col1_width = 120
    @@col2_width = 100
    @@grid_horizontal_spacing = 30
    @@grid_vertical_spacing = 5
    @@row_height = 20

    attr_accessor :grid_width, :grid_height, :x_player_type, :o_player_type, :first_player
    attr_accessor :x_player_type_options, :o_player_type_options
    attr_accessor :grid_width_options, :grid_height_options
    attr_accessor :first_player_options

    before_body do
        self.grid_height = 3
        self.grid_width = 3
        self.x_player_type = "human"
        self.o_player_type = "computer"
        self.first_player = "X"

        # select options
        self.x_player_type_options = ["human", "computer"]
        self.o_player_type_options = ["human", "computer"]
        self.grid_width_options = (3..8).to_a.map{|i| i.to_s}
        self.grid_height_options = (3..8).to_a.map{|i| i.to_s}
        self.first_player_options = ["X", "O"]
    end

    body {
        shell {
            text "Tic Tac Toe"

            grid_layout {
                num_columns 1
                make_columns_equal_width true
            }
            label {
                text "Grid Settings"
                font height: 14, style: :bold
            }
            composite {
                grid_layout {
                    num_columns 2
                    make_columns_equal_width false
                    horizontal_spacing @@grid_horizontal_spacing
                    vertical_spacing @@grid_vertical_spacing
                }
                label {
                    layout_data {
                        width_hint @@col1_width
                    }
                    text "Number of Rows"
                }
                combo(:read_only) {
                    layout_data {
                        width_hint @@col2_width
                    }
                    selection <=> [self, :grid_height]
                }
                label {
                    layout_data {
                        width_hint @@col1_width
                    }
                    text "Number of Columns"
                }
                combo(:read_only) {
                    layout_data {
                        width_hint @@col2_width
                    }
                    selection <=> [self, :grid_width]
                }
            }
            label {
                text "Players Settings"
                font height: 14, style: :bold
            }
            composite {
                grid_layout {
                    num_columns 2
                    make_columns_equal_width false
                    horizontal_spacing @@grid_horizontal_spacing
                    vertical_spacing @@grid_vertical_spacing
                }
                label {
                    layout_data {
                        width_hint @@col1_width
                    }
                    text "Player X is a"
                }
                combo(:read_only) {
                    layout_data {
                        width_hint @@col2_width
                    }
                    selection <=> [self, :x_player_type]
                }
                label {
                    layout_data {
                        width_hint @@col1_width
                    }
                    text "Player O is a"
                }
                combo(:read_only) {
                    layout_data {
                        width_hint @@col2_width
                    }
                    selection <=> [self, :o_player_type]
                }
                label {
                    layout_data {
                        width_hint @@col1_width
                    }
                    text "First player to go"
                }
                combo(:read_only) {
                    layout_data {
                        width_hint @@col2_width
                    }
                    selection <=> [self, :first_player]
                }
            }
            button {
                text 'Start Game'
                layout_data(:fill, :center, true, false)
                on_widget_selected do
                    message_box {
                        text 'Start Game'
                        message "Rows: #{self.grid_height}, Columns: #{self.grid_width}"
                    }.open
                end
            }
        }
    }
end

GUI.launch
