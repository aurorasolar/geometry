require 'minitest/autorun'
require 'geometry/edge'

def Edge(*args)
  Geometry::Edge.new(*args)
end

describe Geometry::Edge do
  Edge = Geometry::Edge
  subject { Geometry::Edge.new [0,0], [1,1] }

  it "must create an Edge object" do
    edge = Edge.new([0,0], [1,0])
    assert_kind_of(Geometry::Edge, edge)
    assert_equal(Geometry::Point[0,0], edge.first)
    assert_equal(Geometry::Point[1,0], edge.last)
  end

  it "must handle equality" do
    edge1 = Edge.new([1,0], [0,1])
    edge2 = Edge.new([1,0], [0,1])
    edge3 = Edge.new([1,1], [5,5])
    assert_equal(edge1, edge2)
    refute_equal edge1, edge3
  end

  it "must return the height of the edge" do
    edge = Edge([0,0], [1,1])
    assert_equal(1, edge.height)
  end

  it "must return the width of the edge" do
    edge = Edge([0,0], [1,1])
    assert_equal(1, edge.width)
  end

  it "must convert an Edge to a Vector" do
    assert_equal Edge.new([0,0], [1,0]).vector, Vector[1,0]
  end

  it "must return the normalized direction of a vector" do
    assert_equal Edge.new([0,0], [1,0]).direction, Vector[1,0]
  end

  it "must return true for parallel edges" do
    assert_equal Edge.new([0,0], [1,0]).parallel?(Edge.new([0,0], [1,0])), 1
    assert_equal Edge.new([0,0], [1,0]).parallel?(Edge.new([1,0], [2,0])), 1
    assert_equal Edge.new([0,0], [1,0]).parallel?(Edge.new([3,0], [4,0])), 1
    assert_equal Edge.new([0,0], [1,0]).parallel?(Edge.new([3,1], [4,1])), 1
  end

  it "must return false for non-parallel edges" do
    assert_equal Edge.new([0,0], [2,0]).parallel?(Edge.new([1,-1], [1,1])), false
  end

  it "must clone and reverse" do
    reversed = subject.reverse
    assert_equal reversed.to_a, subject.to_a.reverse
    _(reversed).wont_be_same_as subject
  end

  it "must reverse itself" do
    original = subject.to_a
    subject.reverse!
    assert_equal subject.to_a, original.reverse
  end

  describe "spaceship" do
    it "ascending with a Point" do
      edge = Edge.new [0,0], [1,1]
      assert_equal edge <=> Point[0,0], 0
      assert_equal edge <=> Point[1,0], -1
      assert_equal edge <=> Point[0,1], 1
      assert_nil edge <=> Point[2,2]
    end

    it "descending with a Point" do
      edge = Edge.new [1,1], [0,0]
      assert_equal edge <=> Point[0,0], 0
      assert_equal edge <=> Point[1,0], 1
      assert_equal edge <=> Point[0,1], -1
      assert_nil edge <=> Point[2,2]
    end
  end

  describe "when finding an intersection" do
    it "must find the intersection of two end-intersecting Edges" do
      intersection = Edge.new([0,0],[1,1]).intersection(Edge.new([0,1],[1,1]))
      assert_kind_of Geometry::Point, intersection
      assert_equal intersection, Geometry::Point[1,1]
    end

    it "must find the intersection of two collinear end-intersecting Edges" do
      intersection = Edge.new([2,2], [0,2]).intersection(Edge.new([3,2], [2,2]))
      assert_kind_of Geometry::Point, intersection
      assert_equal intersection, Geometry::Point[2,2]

      intersection = Edge.new([0,2], [2,2]).intersection(Edge.new([2,2], [3,2]))
      assert_kind_of Geometry::Point, intersection
      assert_equal intersection, Geometry::Point[2,2]
    end

    it "must find the itersection of two crossed Edges" do
      edge1 = Edge.new [0.0, 0], [2.0, 2.0]
      edge2 = Edge.new [2.0, 0], [0.0, 2.0]
      intersection = edge1.intersection edge2
      assert_kind_of Geometry::Point, intersection
      assert_equal intersection, Geometry::Point[1,1]
    end

    it "must return nil for two edges that do not intersect" do
      assert_nil Edge.new([0,0],[1,0]).intersection(Edge.new([0,1],[1,1]))
    end

    it "must return true for two collinear and overlapping edges" do
      assert_equal Edge.new([0,0],[2,0]).intersection(Edge.new([1,0],[3,0])), true
    end

    it "must return false for collinear but non-overlapping edges" do
      assert_equal Edge.new([0,0],[2,0]).intersection(Edge.new([3,0],[4,0])), false
      assert_equal Edge.new([0,0],[0,2]).intersection(Edge.new([0,3],[0,4])), false
    end

    it "must return nil for two parallel but not collinear edges" do
      assert_nil Edge.new([0,0],[2,0]).intersection(Edge.new([1,1],[3,1]))
    end

    it "must return nil for two perpendicular but not interseting edges" do
      assert_nil Edge.new([0, 0], [2, 0]).intersection(Edge.new([3, 3], [3, 1]))
    end
  end
end
