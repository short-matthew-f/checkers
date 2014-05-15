# require 'debugger'

class Piece
  attr_accessor :pos
  attr_reader :board, :color
  
  def differential(source, target)
    a, b = source
    x, y = target
    [x - a, y - b]
  end
  
  def midpoint(source, target)
    a, b = source
    x, y = target
    [(x + a) / 2, (y + b) / 2]
  end
  
  def initialize(pos, board)
    @pos = pos
    @board = board
    
    @board[pos] = self        
  end
  
  def my_favorite_row
    color == :red ? 0 : 7
  end
  
  def perform_slide(target)
    if can_slide_to?(target) 
      board[self.pos] = nil  
      board[target] = self
      
      true
    else
      false
    end
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
  
  def can_slide_to?(target)
    vec = differential(self.pos, target)
    
    deltas.include?(vec) && board.is_empty?(target) 
  end
  
  def can_jump_to?(target)
    c_pos = self.pos
    vec = differential(c_pos, target)
    
    tiny_vec = smallest_vec(c_pos, target)
    
    if deltas.include?(tiny_vec) && vec[0].even? && board.is_empty?(target)
      only_an_enemy_halfway?(c_pos, target)
    else
      false
    end
  end
  
  def smallest_vec(source, target)
    vec = integral_component(differential(source, target))
  end
  
  def only_an_enemy_halfway?(source, target)
    number_of_spaces = (differential(source, target)[0]).abs       
    direction = integral_component(differential(self.pos, target))    
    middle = board[midpoint(source, target)]
    
    return false if middle.nil? || middle.color == self.color
    
    (1...number_of_spaces).all? do |i|
      search_spot = [source[0] + i * direction[0], source[1] + i * direction[1]]
      if search_spot == midpoint(source, target)
        true
      else
        board[search_spot].nil?
      end
    end
  end

  def integral_component(pos)
    x, y = pos
    g = gcf(x, y)
    
    [x / g, y / g]
  end
  
  def gcf(x,y)
    (1..x.abs).map do |i|
      ((x % i == 0) && (y % i == 0)) ? i : nil
    end.compact.last
  end
  
  def deltas
    self.class::DELTAS
  end
  
  def to_s
    is_a?(King) ? "✪".colorize(color) : "◎".colorize(color)
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