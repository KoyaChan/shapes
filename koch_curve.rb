
class Segment
  attr_reader :p1, :radian, :length

  Location = Struct.new(:x, :y)
  def initialize(p1:0, p2:nil, radian:nil, length:nil)
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

  def divide
    x_y_len = x_y_one_third_len(p1, p2)
    loc_0 = p1
    loc_1 = Location.new(p1.x + x_y_len[:x], p1.y + x_y_len[:y])
    loc_2 = Location.new(loc_1.x + x_y_len[:x], loc_1.y + x_y_len[:y])
    loc_3 = p2
    seg_0 = Segment.new(p1:loc_0, p2:loc_1)
    seg_1 = Segment.new(p1:loc_1, p2:loc_2)
    seg_2 = Segment.new(p1:loc_2, p2:loc_3)
    [seg_0, seg_1, seg_2]
  end

  private

  def calc_p2
    location = Location.new(x: 0, y: 0)
    location.x = (p1.x + Math.cos(radian) * length).round(3)
    location.y = (p1.y + Math.sin(radian) * length).round(3)
    location
  end

  def x_y_one_third_len(loc1, loc2)
    x_len = (loc2.x - loc1.x) / 3
    y_len = (loc2.y - loc1.y) / 3
    { x:x_len, y:y_len }
  end
end




