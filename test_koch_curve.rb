require 'test/unit'
require './koch_curve'
require './shapes'

class TestKochCurve < Test::Unit::TestCase
  def setup
    @location = Segment::Location.new(x: 100.0 / 3.0, y: 0)
    @segment = Segment.new(p1: @location,
                           radian: Math::PI * 1.0 / 3.0,
                           length: 100.0 / 3.0)
  end

  def test_triangle
    p1 = Location.new(x: 0, y: 0)
    p2 = Location.new(x: 10, y: 0)
    segment = Segment.new(p1: p1, p2: p2)
    koch = KochCurve.new
    triangle = koch.triangle(segment)
    assert_equal 2, triangle.size
    assert_equal Segment, triangle[0].class
    assert_equal KochCurve::Pizza_radian.round(3), triangle[0].radian.round(3)
    assert_equal (KochCurve::Pizza_radian * 5).round(3), triangle[1].radian.round(3)
  end


  def test_make_koch_curve_segments_returns_array_with_4_segments
    koch = KochCurve.new(base: @segment)
    next_segs = koch.make_koch_curve_segments
    assert_equal Array, next_segs.class
    assert_equal 1, next_segs.size
    next_segs.each do |a_seg|
      assert_equal Segment, a_seg.class
    end
  end

  def test_make_koch_curve_segments_returns_result_of_recursive_call
    koch = KochCurve.new(base: @segment)
    next_segs = koch.make_koch_curve_segments(num: 1)
    assert_equal 4, next_segs.size
  end

  def test_make_koch_curve_segments_with_num_1
    loc21 = Location.new(x: 38.88888889, y: 9.62250449)
    loc25 = Location.new(x: 33.33333333, y: 19.24500897)
    seg21 = Segment.new(p1: loc21, p2: loc25)
    koch21 = KochCurve.new(base: seg21)
    segments = koch21.make_koch_curve_segments(num: 1)
    assert_equal 33.33333333, segments[2].p1.x.round(8)
    assert_equal 33.33333333, segments[1].p2.x.round(8)
    assert_equal 12.83000598, segments[2].p1.y.round(8)
    assert_equal 12.83000598, segments[1].p2.y.round(8)
  end
end

class TestTriangle < Test::Unit::TestCase

  def test_triangle_is_made_with_3_locations
    loc1 = Location.new(x: 10, y: 10)
    loc2 = Location.new(x: 15, y: 15)
    loc3 = Location.new(x: 20, y: 10)

    tri = Triangle.new(p1: loc1, p2: loc2, p3: loc3)
    assert_equal Triangle, tri.class
  end
end
