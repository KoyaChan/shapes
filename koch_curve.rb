class Location
  attr_accessor :x, :y
  def initialize(x: nil, y: nil)
    @x = x.round(3)
    @y = y.round(3)
  end

  def distance(other)
    square = ->(ary) { ary[1]**2 }
    square_each = diff(other).map(&square)
    (sum(square_each)**(1.0 / 2.0)).round(3)
  end

  def locations_to_divide(other, num: 3)
    divide_x = divide_axis_by(num, other, :x)
    divide_y = divide_axis_by(num, other, :y)
    divide_x.zip(divide_y).map do |x, y|
      self.class.new(x: x, y: y)
    end
  end

  def to_h
    { x: x, y: y }
  end

  def diff(other)
    { x: other.x - x, y: other.y - y }
  end

  def divide_axis_by(num, other, axis)
    length = (diff(other)[axis] / num).round(3)
    (1...num).inject([]) do |ary, n|
      ary << to_h[axis] + length * n
    end
  end

  def equal(other)
    diff(other) == { x: 0, y: 0 }
  end

  private

  def sum(ary)
    ary.inject(0) { |e, sum| sum + e }
  end
end

class Segment
  attr_reader :p1

  Pizza_radian = ((1.0 / 3.0) * Math::PI).round(3)

  def self.make_location(x, y)
    Location.new(x: x, y: y)
  end

  def initialize(p1: nil, p2: nil, radian: nil, length: nil)
    @p1 = p1 || Segment.make_location(0, 0)
    @p2 = p2
    @radian = radian
    @length = length
  end

  def p2
    @p2 ||= calc_p2
  end

  def radian
    @radian ||= calc_radian
  end

  def radian=(rad)
    @radian = (rad >= 0 ? rad : (Math::PI * 2 + rad).round(3))
    @p2 = calc_p2
  end

  def length
    @length ||= calc_length
  end

  def divide
    loc0 = p1
    loc1, loc2 = p1.locations_to_divide(p2, num: 3)
    loc3 = p2
    seg0 = self.class.new(p1: loc0, p2: loc1)
    seg1 = self.class.new(p1: loc1, p2: loc2)
    seg2 = self.class.new(p1: loc2, p2: loc3)
    [seg0, seg1, seg2]
  end

  def triangle
    left_seg = clone.rotate(Pizza_radian)

    right_seg = self.class.new(
      p1: left_seg.p2,
      radian: radian,
      length: length
    ).rotate(-Pizza_radian)

    [left_seg, right_seg]
  end

  def rotate(diff_radian)
    self.radian += diff_radian
    self
  end

  private

  def calc_p2
    Segment.make_location(*displace(p1, polar_to_cartesian))
  end

  def polar_to_cartesian
    {
      x: (Math.cos(radian) * length).round(3),
      y: (Math.sin(radian) * length).round(3)
    }
  end

  def calc_radian
    y_len = p2.y - p1.y
    radian = Math.asin(y_len / length).round(3)
    radian += Math::PI * 2 if radian < 0
    radian
  end

  def calc_length
    p1.distance(p2)
  end

  def displace(p, diff)
    [(p.x + diff[:x]).round(3), (p.y + diff[:y]).round(3)]
  end
end

class KochCurve
  Pizza_radian = ((1.0 / 3.0) * Math::PI).round(3)

  attr_reader :segments, :base_seg, :count
  def initialize(base: nil, count: 0)
    @base_seg = base
    @count = count
    @segments = []
  end

  def next_step
    divided = base_seg.divide
    [divided[0], triangle(divided[1]), divided[2]].flatten
  end

  def triangle(segment)
    #ToDo
  end

  private

  def make_segment(p1, p2, radian, length)
    Segment.new(p1: p1, p2: p2, radian: radian, length: length)
  end
end
