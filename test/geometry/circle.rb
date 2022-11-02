require 'minitest/autorun'
require 'geometry/circle'

describe Geometry::Circle do
  Circle = Geometry::Circle

  describe "when constructed with center and radius arguments" do
    let(:circle) { Circle.new [1,2], 3 }

    it "must create a Circle" do
      _(circle).must_be_instance_of(Circle)
    end

    it "must have a center point accessor" do
      assert_equal circle.center, Point[1,2]
    end

    it "must have a radius accessor" do
      assert_equal circle.radius, 3
    end

    it "must compare equal" do
      assert_equal circle, Circle.new([1,2], 3)
    end
  end

  describe "when constructed with named center and radius arguments" do
    let(:circle) { Circle.new :center => [1,2], :radius => 3 }

    it "must create a Circle" do
      _(circle).must_be_instance_of(Circle)
    end

    it "must have a center point accessor" do
      assert_equal circle.center, Point[1,2]
    end

    it "must have a radius accessor" do
      assert_equal circle.radius, 3
    end

    it "must compare equal" do
      assert_equal circle == Circle.new(:center => [1,2], :radius => 3), true
    end
  end

  describe "when constructed with named center and diameter arguments" do
    let(:circle) { Circle.new center:[1,2], diameter:4 }

    it "must be a CenterDiameterCircle" do
      _(circle).must_be_instance_of(Geometry::CenterDiameterCircle)
      assert_kind_of Circle, circle
    end

    it "must have a center" do
      assert_equal circle.center, Point[1,2]
    end

    it "must have a diameter" do
      assert_equal circle.diameter, 4
    end

    it "must calculate the correct radius" do
      assert_equal circle.radius, 2
    end

    it "must compare equal" do
      assert_equal circle, Circle.new([1,2], :diameter => 4)
    end
  end

  describe "when constructed with a diameter and no center" do
    let(:circle) { Circle.new :diameter => 4 }

    it "must be a CenterDiameterCircle" do
      _(circle).must_be_instance_of(Geometry::CenterDiameterCircle)
      assert_kind_of Circle, circle
    end

    it "must have a nil center" do
      assert_kind_of Geometry::PointZero, circle.center
    end

    it "must have a diameter" do
      assert_equal circle.diameter, 4
    end

    it "must calculate the correct radius" do
      assert_equal circle.radius, 2
    end
  end

  describe "properties" do
    subject { Circle.new center:[1,2], :diameter => 4 }

    it "must have a bounds property that returns a Rectangle" do
      assert_equal subject.bounds, Rectangle.new([-1,0], [3,4])
    end

    it "must have a minmax property that returns the corners of the bounding rectangle" do
      assert_equal subject.minmax, [Point[-1,0], Point[3,4]]
    end

    it "must have a max property that returns the upper right corner of the bounding rectangle" do
      assert_equal subject.max, Point[3,4]
    end

    it "must have a min property that returns the lower left corner of the bounding rectangle" do
      assert_equal subject.min, Point[-1,0]
    end
  end
end
