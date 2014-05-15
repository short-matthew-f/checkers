class CheckerBoard
  def self.positions
    (0..7).map do |row|
      (0..7).map do |col|
        [row, col]
      end
    end.flatten(1)
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
  end
  
  def to_s
    @grid.each_with_index.map do |row, r_index|
      row.each_with_index.map do |col, c_index|
        bg_color = (r_index + c_index) % 2 == 0 ? :white : :cyan
        
        if col.is_a?(Piece)
          " #{col} ".colorize(col.color)
        else
          "   "
        end.colorize(background: bg_color)
      end.join
    end.join("\n")
  end
  
  protected
  
  def add_pieces_to_grid
    (0..2).each do |row|
      [0, 2, 4, 6].each do |col|
        BlackPiece.new([row, col + (1 - row % 2)], self)
        RedPiece.new([5 + row, col + row % 2], self)
      end
    end
  end
end