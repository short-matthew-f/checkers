require "./checker_math.rb"

class Piece
  include CheckerMath
  
  attr_accessor :pos
  attr_reader :board, :color
  
  def initialize(pos, board)
    @pos = pos
    @board = board
    
    @board[pos] = self        
  end
  
  protected
  
  def perform_slide(target)
    if can_slide_to?(target) 
      board[self.pos] = nil  
      board[target] = self
      
      true
    else
      false
    end
  end
  
  def can_slide_to?(target)
    vec = differential(self.pos, target)
    
    deltas.include?(vec) && board.is_empty?(target) 
  end
  
  def perform_jump(target)
    if can_jump_to?(target)
      board[self.pos] = nil
      board[midpoint(self.pos, target)] = nil
      board[target] = self
      
      true
    else
      false
    end
  end
  
  # can_jump_to?(target) requires more logic, so we build up our checks
  
  def empties_between(source, target)
    spaces = (differential(source, target)[0]).abs 
    dir = smallest_vec(source, target)
    
    [].tap do |empties|
      (1...spaces).each do |i|
        pos = move(source, dir, i)
        empties << pos if board.is_empty?(pos)
      end
    end
  end
  
  def only_an_enemy_halfway?(source, target)    
    middle = board[midpoint(source, target)]
    
    return false if middle.nil? || middle.color == self.color
    
    empties_between(source, target).count == 1
  end
  
  def can_jump_to?(target)
    c_pos = self.pos
    vec, dir = differential(c_pos, target), smallest_vec(c_pos, target)
  
    deltas.include?(dir)      && 
      vec[0].even?            && 
      board.is_empty?(target) &&
      only_an_enemy_halfway?(c_pos, target)
  end

  def deltas
    self.class::DELTAS
  end
  
  def to_s
    is_a?(King) ? "✪".colorize(color) : "◎".colorize(color)
  end
  
  def my_favorite_row
    color == :red ? 0 : 7
  end
end

class BlackPawn < Piece
  DELTAS = [
    [1, -1], [1, 1]
  ]  

  def initialize(pos, board)
    @color = :black
    super(pos, board)
  end
end

class RedPawn < Piece
  DELTAS = [
    [-1, -1], [-1, 1]
  ]
  
  def initialize(pos, board)
    @color = :red
    super(pos, board)
  end
end

class King < Piece
  DELTAS = [
    [1, -1], [1, 1],
    [-1, -1], [-1, 1]
  ]     
end

class RedKing < King
  def initialize(pos, board)
    @color = :red
    super(pos, board)
  end
end

class BlackKing < King
  def initialize(pos, board)
    @color = :black
    super(pos, board)
  end
end