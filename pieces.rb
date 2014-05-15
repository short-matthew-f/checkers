class Piece
  attr_reader :pos, :board, :color
  
  def initialize(pos, board)
    @pos = pos
    @board = board
    
    @board[pos] = self        
  end
  
  def deltas
    self.class::DELTAS
  end
  
  def to_s
    if self.is_a?(King)
      self.color == :red ? "✪" : "✪"
    else
      self.color == :red ? "◎" : "◎"
    end
  end
  
end

class RedPiece < Piece
  DELTAS = [
    [-1, -1], [-1, 1]
  ]
  
  def initialize(pos, board)
    @color = :red
    super(pos, board)
  end
end

class BlackPiece < Piece
  DELTAS = [
    [1, -1], [1, 1]
  ]  

  def initialize(pos, board)
    @color = :black
    super(pos, board)
  end
end

class King < Piece
  DELTAS = [
    [1, -1], [1, 1],
    [-1, -1], [-1, 1]
  ]    
  
  def initialize(pos, board, color)
    @color = color
    super(pos, board)
  end
end 