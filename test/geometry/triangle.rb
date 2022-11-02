require 'minitest/autorun'
require 'geometry/triangle'

describe Geometry::Triangle do
  Triangle = Geometry::Triangle

  describe "when constructed with 3 points" do
    let(:triangle) { Triangle.new [0,0], [0,1], [1,0] }

    it "must create a scalene Triangle" do
      _(triangle).must_be_instance_of Geometry::ScaleneTriangle
      assert_kind_of Triangle, triangle
    end

    it "must have a points accessor" do
      assert_equal triangle.points, [Point[0,0], Point[0,1], Point[1,0]]
    end
  end

  describe "when constructed with a point and a leg length" do
    let(:triangle) { Triangle.new [0,0], 1 }

    it "must create a right Triangle" do
      _(triangle).must_be_instance_of Geometry::RightTriangle
      assert_kind_of Triangle, triangle
    end

    it "must have a points accessor" do
      assert_equal triangle.points, [Point[0,0], Point[0,1], Point[1,0]]
    end
  end
end
