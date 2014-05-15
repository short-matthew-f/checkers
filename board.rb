class CheckerBoard
  def self.positions
    (0..7).map do |row|
      (0..7).map do |col|
        [row, col]
      end
    end.flatten(1)
  end
  
  def initialize
    @board = setup_board
    
  end
  
  def [](pos)
    x, y = pos
    @board[x][y]
  end
  
  def []=(pos, piece)
    x, y = pos
    @board[x][y] = piece
  end
  
  protected
  
  def setup_board
    board = Array.new(8) { Array.new(8) }
    
    add_pieces_to(board)
  end
  
  def add_pieces_to(board)
    (0..2).each do |row|
      [0, 2, 4, 6].each do |col|
        BlackPiece.new([row, col + (1 - row % 2)])
        RedPiece.new([5 + row, col + row % 2])
      end
    end
  end
end