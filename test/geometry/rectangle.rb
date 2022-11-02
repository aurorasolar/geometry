require 'minitest/autorun'
require 'geometry/rectangle'

def Rectangle(*args)
  Geometry::Rectangle.new(*args)
end

describe Geometry::Rectangle do
  Rectangle = Geometry::Rectangle

  describe "when initializing" do
    it "must accept two corners as Arrays" do
      rectangle = Rectangle.new([1,2], [2,3])
      assert_kind_of Geometry::Rectangle, rectangle
      assert_equal rectangle.height, 1
      assert_equal rectangle.width, 1
      assert_equal rectangle.origin, Point[1,2]
    end

    it "must accept two named corners as Arrays" do
      rectangle = Rectangle.new(from:[1,2], to:[2,3])
      assert_kind_of Geometry::Rectangle, rectangle
      assert_equal rectangle.height, 1
      assert_equal rectangle.width, 1
      assert_equal rectangle.origin, Point[1,2]
    end

    it "must accept named center point and size arguments" do
      rectangle = Rectangle.new(center:[1,2], size:[3,4])
      assert_kind_of Geometry::Rectangle, rectangle
      assert_equal rectangle.height, 4
      assert_equal rectangle.width, 3
      assert_equal rectangle.center, Point[1,2]
    end

    it "must reject a named center argument with no size argument" do
      assert_raises(ArgumentError) { Rectangle.new(center:[1,2]) }
    end

    it "must accept named origin point and size arguments" do
      rectangle = Rectangle.new(origin:[1,2], size:[3,4])
      assert_kind_of Geometry::Rectangle, rectangle
      assert_equal rectangle.height, 4
      assert_equal rectangle.width, 3
      assert_equal rectangle.origin, Point[1,2]
    end

    it "must reject a named origin argument with no size argument" do
      assert_raises(ArgumentError) { Rectangle.new(origin:[1,2]) }
    end

    it "must accept a sole named size argument that is an Array" do
      rectangle = Rectangle.new(size:[1,2])
      assert_kind_of Geometry::Rectangle, rectangle
      assert_equal rectangle.origin, Point[0,0]
      assert_equal rectangle.height, 2
      assert_equal rectangle.width, 1
    end

    it "must accept a sole named size argument that is a Size" do
      rectangle = Rectangle.new(size:Size[1,2])
      assert_kind_of Geometry::Rectangle, rectangle
      assert_equal rectangle.origin, Point[0,0]
      assert_equal rectangle.height, 2
      assert_equal rectangle.width, 1
    end

    it "must accept named width and height arguments" do
      rectangle = Rectangle.new(width:1, height:3)
      assert_kind_of Geometry::Rectangle, rectangle
      assert_equal rectangle.height, 3
      assert_equal rectangle.width, 1
    end

    it "must reject width or height by themselves" do
      assert_raises(ArgumentError) { Rectangle.new(height:1) }
      assert_raises(ArgumentError) { Rectangle.new(width:1) }
    end
  end

  describe "comparison" do
    it "must compare equal" do
      rectangle = Rectangle [1,2], [3,4]
      assert_equal rectangle, Rectangle([1,2], [3, 4])
    end
  end

  describe "inset" do
    subject { Rectangle.new([0,0], [10,10]) }

    it "must inset equally" do
      assert_equal subject.inset(1), Rectangle.new([1,1], [9,9])
    end

    it "must inset vertically and horizontally" do
      assert_equal subject.inset(1,2), Rectangle.new([1,2], [9,8])
      assert_equal subject.inset(x:1, y:2), Rectangle.new([1,2], [9,8])
    end

    it "must inset from individual sides" do
      assert_equal subject.inset(1,2,3,4), Rectangle.new([2,3], [6,9])
      assert_equal subject.inset(top:1, left:2, bottom:3, right:4), Rectangle.new([2,3], [6,9])
    end
  end

  describe "properties" do
    subject { Rectangle.new([1,2], [3,4]) }
    let(:rectangle) { Rectangle [1,2], [3,4] }

    it "have a center point property" do
      assert_equal rectangle.center, Point[2,3]
    end

    it "have a width property" do
      assert_equal(2, rectangle.width)
    end

    it "have a height property" do
      assert_equal(2, rectangle.height)
    end

    it "have an origin property" do
      assert_equal(Point[1,2], rectangle.origin)
    end

    it "have an edges property that returns 4 edges" do
      edges = rectangle.edges
      assert_equal(4, edges.size)
      edges.each {|edge| assert_kind_of(Geometry::Edge, edge)}
    end

    it "have a points property that returns 4 points" do
      points = rectangle.points
      assert_equal(4, points.size)
      points.each {|point| assert_kind_of(Geometry::Point, point)}
    end

    it "must have a bounds property that returns a Rectangle" do
      assert_equal subject.bounds, Rectangle.new([1,2], [3,4])
    end

    it "must have a minmax property that returns the corners of the bounding rectangle" do
      assert_equal subject.minmax, [Point[1,2], Point[3,4]]
    end

    it "must have a max property that returns the upper right corner of the bounding rectangle" do
      assert_equal subject.max, Point[3,4]
    end

    it "must have a min property that returns the lower left corner of the bounding rectangle" do
      assert_equal subject.min, Point[1,2]
    end
  end
end
