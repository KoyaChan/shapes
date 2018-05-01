require './shapes'
require 'cairo'

class KochCurve
  attr_reader :segments, :base_seg, :count

  Pizza_radian = Math::PI * 1.0 / 3.0

  def initialize(base: nil, count: 0)
    @base_seg = base
    @count = count
  end

  def make_and_print_points(num = @count)
    segments = make_koch_curve_segments(num: num)
    segments.each(&method(:print_p1_of_segment))
    segments[-1].p2.print
  end

  def print_p1_of_segment(segment)
    segment.p1.print
  end

  def draw(context, num = @count)
    segments = make_koch_curve_segments(num: num)
    add_to_path = ->(segment) { segment.add_to_path(context) }
    segments.each(&add_to_path)
    context.stroke
  end

  def make_koch_curve_segments(num: 0, seg: base_seg)
    return [seg] if num.zero?
    divided = seg.divide
    next_segments = [divided[0], triangle(divided[1]), divided[2]].flatten!
    return next_segments if num == 1
    all_segments = next_segments.map do |segment|
      make_koch_curve_segments(num: num - 1, seg: segment)
    end
    all_segments.flatten
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

width = 2000
height = 1600
format = Cairo::FORMAT_ARGB32
stride = Cairo::Format.stride_for_width(format, width)
data = '\0' * stride * height
surface = Cairo::ImageSurface.new(data, format, width, height, stride)
context = Cairo::Context.new(surface)
context.set_source_color(Cairo::Color::SLATE_GRAY)
context.rectangle(0, 0, width, height)
context.fill

context.set_source_color(Cairo::Color::HOT_MAGENTA)
origin = Location.new(x: 0, y: 100)
base = Segment.new(p1: origin, length: width)
koch = KochCurve.new(base: base)
count = 6
koch.draw(context, count)
surface.write_to_png("./curve#{count}.png")
