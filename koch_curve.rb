class Location
  attr_accessor :x, :y
  def initialize(x: nil, y: nil)
    @x = x.round(3)
    @y = y.round(3)
  end

  def distance(other)
    square = ->(ary) { ary[1]**2 }
    square_each = x_y_pair_of_diff_to(other).map(&square)
    (sum(square_each)**(1.0 / 2.0)).round(3)
  end

  def locations_to_divide(other, num: 3)
    divide_x = divide_axis_by(num, other, :x)
    divide_y = divide_axis_by(num, other, :y)
    x_y_pairs_of_divide_locations = divide_x.zip(divide_y)
    x_y_pairs_of_divide_locations.map do |x, y|
      self.class.new(x: x, y: y)
    end
  end

  def to_h
    { x: x, y: y }
  end

  def x_y_pair_of_diff_to(other)
    { x: other.x - x, y: other.y - y }
  end

  def divide_axis_by(num, other, axis)
    length = (x_y_pair_of_diff_to(other)[axis] / num).round(3)
    (1...num).inject([]) do |ary_of_points_on_axis, n|
      ary_of_points_on_axis << to_h[axis] + length * n
    end
  end

  def equal(other)
    x_y_pair_of_diff_to(other) == { x: 0, y: 0 }
  end

  private

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
    @p2 ||= calc_p2
  end

  def radian
    return @radian unless @radian.nil?
    self.radian = calc_radian
  end

  def radian=(rad)
    @radian = (rad >= 0 ? rad : (Math::PI * 2 + rad).round(3))
    @p2 = calc_p2
    @radian
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

  private

  def origin
    self.class.make_location(0, 0)
  end

  def calc_p2
    self.class.make_location(*displace(p1, polar_to_cartesian))
  end

  def polar_to_cartesian
    {
      x: (Math.cos(radian) * length).round(3),
      y: (Math.sin(radian) * length).round(3)
    }
  end

  def displace(p, diff)
    [(p.x + diff[:x]).round(3), (p.y + diff[:y]).round(3)]
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

  Pizza_radian = Math::PI * 1.0 / 3.0

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
    left_seg = segment.rotate(Pizza_radian)
    right_seg =
      make_segment(
        left_seg.p2,
        nil,
        left_seg.radian - Pizza_radian * 2,
        left_seg.length
      )
    [left_seg, right_seg]
  end

  private

  def make_segment(p1, p2, radian, length)
    Segment.new(p1: p1, p2: p2, radian: radian, length: length)
  end
end
