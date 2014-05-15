require 'colorize'
require "./pieces.rb"
require "./checker_board.rb"
require "./checkers_errors.rb"

class Checkers
  attr_reader :board, :players
  
  def initialize
    @board = CheckerBoard.new
    @players = [:red, :black]
  end
  
  def play
    until game_over?
      player_turn
      swap_players
    end
  end
  
  # protected
  
  def player_turn
    begin
      player_input = get_player_input
      position_list = parse_input(player_input) if valid_input?(player_input)
    rescue StandardError => e
      puts e.message
      retry
    end
  end
  
  def get_player_input
    puts "Please enter the position of the piece and where"
    puts "you want it to jump.  (e.g. c3-d4 or c3-e5-c7)"
    gets.chomp.upcase
  end
  
  def valid_input?(input)
    input[/([A-H][1-8]-)+([A-H][1-8])\z/]
  end
  
  def position_list(input)
    input
      .split('-')
      .map { |english| english_to_position(english) }
  end
  
  def english_to_position(string)
    letters = *('A'..'H')
    [8 - string[1].to_i, letters.index(string[0])]
  end
  
  def swap_players
    @players.rotate!
  end
  
  def current_player
    @players.first
  end
  
  def next_player 
    @players.last
  end
  
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end