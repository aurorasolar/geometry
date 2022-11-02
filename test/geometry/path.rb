require 'minitest/autorun'
require 'geometry/path'

describe Geometry::Path do
  describe "construction" do
    it "must create a Path with no arguments" do
      path = Geometry::Path.new
      assert_kind_of Geometry::Path, path
      refute_nil path.elements
      assert_equal path.elements.size, 0
    end

    it "must create a Path from Points" do
      path = Geometry::Path.new Point[1,1], Point[2,2], Point[3,3]
      assert_equal path.elements.size, 2
      path.elements.each {|a| assert_kind_of Geometry::Edge, a }
    end

    it "with connected Edges" do
      path = Geometry::Path.new Edge.new([1,1], [2,2]), Edge.new([2,2], [3,3])
      assert_equal path.elements.size, 2
      path.elements.each {|a| assert_kind_of Geometry::Edge, a }
    end

    it "with disjoint Edges" do
      path = Geometry::Path.new Edge.new([1,1], [2,2]), Edge.new([3,3], [4,4])
      assert_equal path.elements.size, 3
      path.elements.each {|a| assert_kind_of Geometry::Edge, a }
    end

    it "with Points and Arcs" do
      path = Geometry::Path.new [0,0], [1.0,0.0], Arc.new(center:[1,1], radius:1, start:-90*Math::PI/180, end:0), [2.0,1.0], [1,2]
      assert_equal path.elements.size, 3
      assert_kind_of Geometry::Edge, path.elements[0]
      assert_kind_of Geometry::Arc, path.elements[1]
      assert_kind_of Geometry::Edge, path.elements[2]
    end

    it "with Edges and Arcs" do
      path = Geometry::Path.new Edge.new([0,0], [1.0,0.0]), Arc.new(center:[1,1], radius:1, start:-90*Math::PI/180, end:0), Edge.new([2.0,1.0], [1,2])
      assert_equal path.elements.size, 3
      assert_kind_of Geometry::Edge, path.elements[0]
      assert_kind_of Geometry::Arc, path.elements[1]
      assert_kind_of Geometry::Edge, path.elements[2]
    end

    it "with disjoint Edges and Arcs" do
      path = Geometry::Path.new Edge.new([0,0], [1,0]), Arc.new(center:[2,1], radius:1, start:-90*Math::PI/180, end:0), Edge.new([3,1], [1,2])
      assert_equal path.elements.size, 4
      assert_kind_of Geometry::Edge, path.elements[0]
      assert_kind_of Geometry::Edge, path.elements[1]
      assert_kind_of Geometry::Arc, path.elements[2]
      assert_kind_of Geometry::Edge, path.elements[3]
    end

    it "with disjoint Arcs" do
      path = Geometry::Path.new Arc.new(center:[2,1], radius:1, start:-90*Math::PI/180, end:0), Arc.new(center:[3,1], radius:1, start:-90*Math::PI/180, end:0)
      assert_equal path.elements.size, 3
      assert_kind_of Geometry::Arc, path.elements[0]
      assert_kind_of Geometry::Edge, path.elements[1]
      assert_kind_of Geometry::Arc, path.elements[2]

      assert_equal path.elements[0].last, path.elements[1].first
    end
  end
end
