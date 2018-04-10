class Location
  attr_accessor :x, :y, :radian, :length
  def initialize(x: nil, y: nil)
    @x = x
    @y = y
  end

  def distance(other)
    ((x - other.x)**2 + (y - other.y)**2)**(1.0 / 2.0)
  end
end

class Segment
  attr_reader :p1

  Pizza_radian = (1.0 / 3.0) * Math::PI

  def self.make_location(x, y)
    Location.new(x: x, y: y)
  end

  def initialize(p1: 0, p2: nil, radian: nil, length: nil)
    @p1 = p1
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

  def length
    @length ||= calc_length
  end

  def divide
    loc0, loc1, loc2, loc3 = locations_to_divide(p1, p2)
    seg0 = self.class.new(p1: loc0, p2: loc1)
    seg1 = self.class.new(p1: loc1, p2: loc2)
    seg2 = self.class.new(p1: loc2, p2: loc3)
    [seg0, seg1, seg2]
  end

  def triangle
    left_seg = self.class.new(
      p1: p1,
      radian: radian + Pizza_radian.round(3),
      length: length
    )

    right_seg = self.class.new(
      p1: left_seg.p2,
      radian: radian - Pizza_radian.round(3),
      length: length
    )

    [left_seg, right_seg]
  end

  private

  def calc_p2
    diff = {
      x: (Math.cos(radian) * length).round(3),
      y: (Math.sin(radian) * length).round(3)
    }
    Segment.make_location(*displace(p1, diff))
  end

  def one_third_len(loc1, loc2)
    x_len = ((loc2.x - loc1.x) / 3).round(3)
    y_len = ((loc2.y - loc1.y) / 3).round(3)
    { x: x_len, y: y_len }
  end

  def displace(p, diff)
    [(p.x + diff[:x]).round(3), (p.y + diff[:y]).round(3)]
  end

  def locations_to_divide(p1, p2)
    diff = one_third_len(p1, p2)
    mid1 = Segment.make_location(*displace(p1, diff))
    mid2 = Segment.make_location(*displace(mid1, diff))
    [
      p1,
      mid1,
      mid2,
      p2
    ]
  end

  def calc_radian
    y_len = p2.y - p1.y
    Math.asin(y_len / length).round(3)
  end

  def calc_length
    p1.distance(p2)
  end
end

class KochCurve
  attr_reader :segments, :base_seg, :count
  def initialize(base: nil, count: 0)
    @base_seg = base
    @count = count
    @segments = []
  end

  def next_step
    divided = base_seg.divide
    [divided[0], divided[1].triangle, divided[2]].flatten
  end

  private

  def make_segment(p1, p2, radian, length)
    base_seg.class.new(p1: p1, p2: p2, radian: radian, length: length)
  end
end
