require 'minitest/autorun'
require 'geometry/square'

describe Geometry::Square do
  Square = Geometry::Square

  describe "when constructed" do
    it "must create a Square from two Points" do
      square = Square.new from:[1,2], to:[3,4]
      assert_kind_of Geometry::Square, square
    end

    it "must reorder swapped points when constructed from two Points" do
      square = Geometry::Square.new from:[3,4], to:[1,2]
      assert_kind_of Geometry::Square, square
      assert_equal square.instance_eval('@points[0]'), Point[1,2]
      assert_equal square.instance_eval('@points[1]'), Point[3,4]
    end

    it "must accept an origin Point and a size" do
      square = Square.new origin:[1,2], size:5
      assert_kind_of Geometry::Square, square
      assert_equal square.origin, Point[1,2]
      assert_equal square.height, 5
      assert_equal square.width, 5
    end
  end

  describe "properties" do
    subject { Square.new from:[2,3], to:[3,4] }

    it "must have an origin accessor" do
      assert_equal subject.origin, Point[2,3]
    end
  end
end

describe Geometry::CenteredSquare do
  describe "when constructed" do
    it "must create a CenteredSquare from a center point and a size" do
      square = Geometry::CenteredSquare.new [2,3], 5
      _(square).must_be_instance_of Geometry::CenteredSquare
      assert_kind_of Geometry::Square, square
    end
  end

  describe "properties" do
    let(:square) { Geometry::CenteredSquare.new [2,3], 4 }

    it "must have a center property" do
      assert_equal square.center, Point[2,3]
    end

    it "must have a points property" do
      assert_equal square.points, [Point[0,1], Point[4,1], Point[4,5], Point[0,5]]
    end

    it "must have a height property" do
      assert_equal square.height, 4
    end

    it "must have a width property" do
      assert_equal square.width, 4
    end
  end
end
