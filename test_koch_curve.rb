require 'test/unit'
require './koch_curve'

class TestKochCurve < Test::Unit::TestCase
  def setup
    @location = Segment::Location.new(100.0 / 3.0, 0)
    @segment = Segment.new(p1: @location,
                           radian: Math::PI * 1.0 / 3.0,
                           length: 100.0 / 3.0)
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
