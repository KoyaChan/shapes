require 'test/unit'
require './koch_curve'

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
    assert_equal KochCurve::Pizza_radian, triangle[0].radian
    assert_equal (KochCurve::Pizza_radian * 5).round(3), triangle[1].radian
  end


  def test_next_step_returns_array_with_4_segments
    koch = KochCurve.new(base: @segment)
    next_segs = koch.next_step
    assert_equal Array, next_segs.class
    assert_equal 4, next_segs.size
    next_segs.each do |a_seg|
      assert_equal Segment, a_seg.class
    end
  end
end

# Todo
# - Segmentを負の方向へrotateしたあと、segment.radianの値を再計算させる
