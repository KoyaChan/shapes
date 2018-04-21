require 'test/unit'
require './koch_curve'

class TestSegment < Test::Unit::TestCase
  def setup
    @location = Segment.make_location(100.0 / 3.0, 0)
    @segment = Segment.new(p1: @location,
                           radian: Math::PI * 1.0 / 3.0,
                           length: 100.0 / 3.0)
  end

  def test_location_has_x_and_y
    assert_equal (100.0 / 3.0).round(3), @location.x
    assert_equal 0, @location.y
  end

  def test_segment_is_made_from_p1_radian_length
    assert_equal @segment.class, Segment
  end

  def test_segment_is_made_from_p1_p2
    p1 = Segment.make_location(0, 1)
    p2 = Segment.make_location(2, 3)
    assert_equal Segment, Segment.new(p1: p1, p2: p2).class
  end

  def test_get_p2_from_segment
    lc_p2 = Segment.make_location(100.0 / 3.0 + 100.0 / (3.0 * 2),
                                  100.0 / 3.0 * 1.0 / 2.0 * (3.0**(1.0 / 2.0)))
    assert_equal lc_p2.x.round(3), @segment.p2.x
    assert_equal lc_p2.y.round(3), @segment.p2.y
  end

  def test_get_radian_from_segment_made_from_p1_p2
    lc_p1 = Segment.make_location(0, 0)
    lc_p2 = Segment.make_location(1.0 / 2.0, 1.0 / 2.0 * (3.0**(1.0 / 2.0)))
    segment = Segment.new(p1: lc_p1, p2: lc_p2)
    assert_equal (Math::PI * 1.0 / 3.0).round(3), segment.radian
    assert_equal 1, segment.length
  end

  def test_radian_is_always_positive
    @segment.radian -= Math::PI
    assert_equal (Math::PI * 4.0 / 3.0).round(3), @segment.radian
  end 

  def test_p2_changes_when_radian_is_changed
    @segment.radian += Math::PI * 2.0 / 3.0
    lc_p2 =  Segment.make_location(0, 0)
    assert_equal lc_p2.x, @segment.p2.x
    assert_equal lc_p2.y, @segment.p2.y
  end

  def test_get_length_from_segment_made_from_p1_p2
    lc_p1 = Segment.make_location(1, 1)
    lc_p2 = Segment.make_location(2, 1 + 2 * (1.0 / 2.0 * (3.0**(1.0 / 2.0))))
    segment = Segment.new(p1: lc_p1, p2: lc_p2)
    assert_equal 2, segment.length
  end

  def test_segment_is_divided_to_3_parts
    assert_equal 3, @segment.divide.size
    @segment.divide.each do |part|
      assert_equal part.class, Segment
    end
  end

  def test_segment_is_divided_to_3_equal_length
    p1 = Segment.make_location(0, 0)
    p2 = Segment.make_location(99, 66)
    seg = Segment.new(p1: p1, p2: p2)
    seg.divide.each_with_index do |part, index|
      assert_equal p1.x + index * 33 , part.p1.x
      assert_equal p1.y + index * 22, part.p1.y
      assert_equal p1.x + (index + 1) * 33, part.p2.x
      assert_equal p1.y + (index + 1) * 22, part.p2.y
    end
  end

  def test_triangle_returns_array_with_2_segments
    tri = @segment.triangle
    assert_equal Array, tri.class
    assert_equal 2, tri.size
    tri.each do |seg|
      assert_equal Segment, seg.class
    end
  end

  def test_triangle_makes_Pizza_radian
    tri = @segment.triangle
    tri.each do |seg|
      assert_equal @segment.length, seg.length
    end
    assert_equal @segment.radian + Segment::Pizza_radian, tri[0].radian
    assert_equal @segment.radian - Segment::Pizza_radian, tri[1].radian
  end

  def test_rotate
    diff = (1.0 / 2.0) * Math::PI
    assert_equal @segment.radian + diff, @segment.rotate(diff).radian
  end
end

class TestLocation < Test::Unit::TestCase
  def test_location_is_made_from_x_y_values
    loc = Location.new(x: 0, y: 1)
    assert_equal Location, loc.class
  end

  def test_location_distance_method
    loc = Location.new(x: 0, y: 0)
    loc1 = Location.new(x: 1, y: 2)
    assert_equal (5**(1.0 / 2.0)).round(3), loc.distance(loc1)
  end

  def test_diff_makes_new_hash_with_diff_of_each
    loc1 = Location.new(x: 10, y:4)
    loc2 = Location.new(x: 8, y: 3)
    h = {x: -2, y: -1}
    assert_equal h, loc1.diff(loc2)
  end

  def test_locations_to_divide
    loc1 = Location.new(x: 1, y: 2)
    loc2 = Location.new(x: 7, y: 11)
    locations = loc1.locations_to_divide(loc2, num: 3)
    assert_equal Array, locations.class
    assert_equal 2, locations.size
    div1 = Location.new(x: 3, y: 5)
    div2 = Location.new(x: 5, y: 8)
    assert div1.equal(locations[0])
    assert div2.equal(locations[1])
  end

  def test_divide_axis_by_factor
    loc1 = Location.new(x: 1, y: 2)
    loc2 = Location.new(x: 7, y: 11)
    divide_x = loc1.divide_axis_by(3, loc2, :x)
    divide_y = loc1.divide_axis_by(3, loc2, :y)
    assert_equal [3, 5], divide_x
    assert_equal [5, 8], divide_y
  end
end

# ToDO
# Location#divide_axis_byの to_h は axisの :x を @x に対応付けられないか
