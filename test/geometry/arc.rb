require 'minitest/autorun'
require 'geometry/arc'

describe Geometry::Arc do
  Arc = Geometry::Arc

  describe "when constructed" do
    it "must accept a center point, radius, start and end angles" do
      arc = Geometry::Arc.new center:[1,2], radius:3, start:0, end:90
      assert_kind_of Geometry::Arc, arc
      assert_equal arc.center, Point[1,2]
      assert_equal arc.radius, 3
      assert_equal arc.start_angle, 0
      assert_equal arc.end_angle, 90
    end

    it "must create an Arc from center, start and end points" do
      arc = Geometry::Arc.new center:[1,2], start:[3,4], end:[5,6]
      assert_kind_of Geometry::Arc, arc
      assert_equal arc.center, Point[1,2]
      assert_equal arc.first, Point[3,4]
      assert_equal arc.last, Point[5,6]
    end
  end
end
