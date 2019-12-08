# Monkey patch String to add colors
class String
  def colorize(color)
    "\033[#{color}m#{self}\033[0m"
  end

  def blue
    colorize 34
  end

  def green
    colorize 32
  end

  def red
    colorize 31
  end
end

class Integer
  def colorize(color)
    "\033[#{color}m#{self}\033[0m"
  end

  def blue
    colorize 34
  end

  def green
    colorize 32
  end

  def red
    colorize 31
  end
end


# Color class to color everything
class Color
  def self.blue(&block)
    colorize(34, &block)
  end

  def self.green(&block)
    colorize(32, &block)
  end

  def self.red(&block)
    colorize(31, &block)
  end

  def self.colorize(color, &block)
    print "\033[#{color}m"
    block.call
    print "\033[0m"
  end
end
