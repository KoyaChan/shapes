require 'test/unit'
require './koch_curve'

class TestKochCurve < Test::Unit::TestCase
  def setup
    @location = Segment::Location.new(100.0 / 3.0, 0)
    @segment = Segment.new(p1: @location,
                           radian: Math::PI * 1.0 / 3.0,
                           length: 100.0 / 3.0)
  end

  def test_location_has_x_and_y
    assert_equal 100.0 / 3.0, @location.x
    assert_equal 0, @location.y
  end

  def test_segment_is_made_from_p1_radian_length
    assert_equal @segment.class, Segment
  end

  def test_segment_is_made_from_p1_p2
    p1 = Segment::Location.new(0, 1)
    p2 = Segment::Location.new(2, 3)
    assert_equal Segment, Segment.new(p1: p1, p2: p2).class
  end

  def test_get_p2_from_segment
    lc_p2 = Segment::Location.new(100.0 / 3.0 + 100.0 / (3.0 * 2),
                                  100.0 / 3.0 * 1.0 / 2.0 * (3.0**(1.0 / 2.0)))
    assert_equal lc_p2.x.round(3), @segment.p2.x
    assert_equal lc_p2.y.round(3), @segment.p2.y
  end

  def test_get_radian_from_segment_made_from_p1_p2
    lc_p1 = Segment::Location.new(0, 0)
    lc_p2 = Segment::Location.new(1.0 / 2.0, 1.0 / 2.0 * (3.0**(1.0 / 2.0)))
    segment = Segment.new(p1: lc_p1, p2: lc_p2)
    assert_equal Math::PI * 1.0 / 3.0, segment.radian
    assert_equal 1, segment.length
  end

  def test_get_length_from_segment_made_from_p1_p2
    lc_p1 = Segment::Location.new(1, 1)
    lc_p2 = Segment::Location.new(2, 1 + 2 * (1.0 / 2.0 * (3.0**(1.0 / 2.0))))
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
    p1 = Segment::Location.new(0, 0)
    p2 = Segment::Location.new(99, 66)
    seg = Segment.new(p1: p1, p2: p2)
    seg.divide.each_with_index do |part, index|
      assert_equal p1.x + index * 33 , part.p1.x
      assert_equal p1.y + index * 22, part.p1.y
      assert_equal p1.x + (index + 1) * 33, part.p2.x
      assert_equal p1.y + (index + 1) * 22, part.p2.y
    end
  end

end

#ToDO
#- Segment生成でp1, p2が与えられたら radian, lengthを計算する。
