module CheckerMath
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
  
  def smallest_vec(source, target)
    vec = integral_component(differential(source, target))
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
  
  def move(vec, diff, num_times)
    [vec[0] + num_times * diff[0], vec[1] + num_times * diff[1]]
  end
end