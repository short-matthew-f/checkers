require 'colorize'
require "./pieces.rb"
require "./checker_board.rb"

class Checkers
  def initialize
    board = CheckerBoard.new
    
    @players = [:red, :black]
  end
  
  def play
    
  end
  
  protected
  
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