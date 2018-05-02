class Location
  attr_accessor :x, :y
  def initialize(x: nil, y: nil)
    @x = x
    @y = y
  end

  def distance(other)
    square = ->(ary) { ary[1]**2 }
    square_each = diff_to(other).map(&square)
    square_root(sum(square_each))
  end

  def locations_to_divide(other, num: 3.0)
    diff = diff_to_divide_by(num, other)
    first_divider = [another(diff)]
    (2...num).inject(first_divider) do |locations, _|
      locations << locations[-1].another(diff)
    end
  end

  def diff_to(other)
    { x: other.x - x, y: other.y - y }
  end

  def another(diff)
    self.class.new(x: x + diff[:x], y: y + diff[:y])
  end

  def diff_to_divide_by(num, other)
    { x: (other.x - x) / num.to_f, y: (other.y - y) / num.to_f }
  end

  def equal(other)
    round_value = ->(_, v) { v.round(8) }
    diff_to(other).map(&round_value) == [0, 0]
  end

  def print
    puts "#{@x.round(8)} #{@y.round(8)}"
  end

  private

  def square_root(value)
    value**(1.0 / 2.0)
  end

  def sum(ary)
    ary.inject(0) { |e, sum| sum + e }
  end
end

class Segment
  attr_reader :p1

  def self.make_location(x, y)
    Location.new(x: x, y: y)
  end

  def initialize(p1: nil, p2: nil, radian: 0, length: 1)
    @p1 = p1 || origin
    @p2 = p2
    return unless @p2.nil?

    @length = length
    self.radian = radian
  end

  def p2
    @p2 ||= calc_p2_from_radian_length
  end

  def radian
    return @radian unless @radian.nil?
    self.radian = calc_radian_from_x_y_and_length
    @radian
  end

  def radian=(rad)
    @radian = positive(rad)
    @p2 = calc_p2_from_radian_length
  end

  def length
    @length ||= calc_length
  end

  def divide(num = 3)
    divide_locs = p1.locations_to_divide(p2, num: num)
    divide_locs.unshift(p1)
    divide_locs.push(p2)
    (0...num).inject([]) do |divided_segments, i|
      divided_segments <<
        self.class.new(
          p1: divide_locs[i],
          p2: divide_locs[i + 1]
        )
    end
  end

  def rotate(diff_radian)
    self.radian += diff_radian
    self
  end

  def invert
    @p1, @p2 = @p2, @p1
    radian = nil
    length = nil
    self
  end

  def add_to_path(context)
    context.move_to(p1.x, p1.y)
    context.line_to(p2.x, p2.y)
  end

  private

  def origin
    self.class.make_location(0, 0)
  end

  def calc_p2_from_radian_length
    p1.another(polar_to_cartesian)
  end

  def polar_to_cartesian
    {
      x: (Math.cos(radian) * length),
      y: (Math.sin(radian) * length)
    }
  end

  def calc_radian_from_x_y_and_length
    rad = Math.asin((p2.y - p1.y) / length)
    p2.x >= p1.x ? rad : Math::PI - rad
  end

  def calc_length
    p1.distance(p2)
  end

  def positive(radian)
    radian >= 0 ? radian : (radian + Math::PI * 2)
  end
end
