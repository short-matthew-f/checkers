class CheckerBoard
  attr_reader :grid
  
  def self.positions
    [].tap do |positions| 
      (0..7).each do |row|
        (0..7).each do |col|
          positions << [row, col]
        end
      end
    end
  end
  
  def dup         # tap requests you yield authority to its usefulness
   CheckerBoard.new.tap do |dup_board|
      pieces.each do |piece|
        piece.class.new(piece.pos, dup_board)
      end
    end
  end
  
  def pieces
    @grid.flatten.compact
  end
  
  def initialize
    @grid = Array.new(8) { Array.new(8) }
    add_pieces_to_grid
  end
  
  def [](pos)
    x, y = pos
    @grid[x][y]
  end
  
  def []=(pos, piece)
    x, y = pos   
    @grid[x][y] = piece
    
    piece.pos = pos unless piece.nil?
  end
  
  def is_empty?(pos)
    x, y = pos
    @grid[x][y].nil? && (0..7).include?(x) && (0..7).include?(y)
  end
  
  def to_s
    @grid.each_with_index.map do |row, r_index|
      "#{8-r_index} ".colorize(:green) +
      row.each_with_index.map do |col, c_index|
        bg_color = (r_index + c_index) % 2 == 0 ? :white : :cyan
        
        if col.is_a?(Piece)
          " #{col} "
        else
          "   "
        end.colorize(background: bg_color)
      end.join
    end.join("\n") + "\n  " +
    ('A'..'H').map { |let| " #{let} " }.join.colorize(:green)
  end
  
  #protected
  
  def promote(position)
    piece = self[position]
    unless piece.is_a?(King)
      self[position] = 
        if piece.color == :red
          RedKing.new(position, self) 
        else 
          BlackKing.new(position, self)
        end
    end
  end
  
  def add_pieces_to_grid
    (0..2).each do |row|
      [0, 2, 4, 6].each do |col|
        BlackPawn.new([row, col + (1 - row % 2)], self)
        RedPawn.new([5 + row, col + row % 2], self)
      end
    end
  end
end