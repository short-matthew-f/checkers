require 'colorize'
require "./pieces.rb"
require "./checker_board.rb"
require "./checkers_errors.rb"

class Checkers
  attr_reader :board, :players
  
  def initialize
    @board = CheckerBoard.new
    @board.add_pieces_to_grid
    @players = [:red, :black]
    @error_message = nil
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
      
      if valid_input?(player_input)
        sequence = position_list(player_input)
      else
        raise CheckersErrors::WhatDidYouTypeError
      end
      
      piece_to_move = @board[sequence.first]
      
      if piece_to_move.color != current_player
        raise CheckersErrors::NotYourPieceError
      end

      piece_to_move.perform_moves(sequence)
      
      if !piece_to_move.is_a?(King) && piece_to_move.is_in_heaven?
        @board.promote(sequence.last)
      end
          
    rescue StandardError => e
      @error_message = e.message
      retry
    end
  end
  
  def get_player_input
    system("clear")
    puts "\n\n"
    puts @board
    
    puts "\n" + "#{@error_message}".red.blink if @error_message
    @error_message = nil
    
    puts "\n#{current_player.capitalize}, please enter the position of the piece and where"
    puts "you want it to jump.  (e.g. c3-d4 or c3-e5-c7)"
    print "> "
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
  
  def game_over?
    false
  end
  
end

if __FILE__ == $PROGRAM_NAME
  game = Checkers.new
  game.play
end