require 'minitest/autorun'
require 'geometry/polygon'

describe Geometry::Polygon do
  Polygon = Geometry::Polygon

  let(:cw_unit_square) { Polygon.new([0,0], [0,1], [1,1], [1,0]) }
  let(:unit_square) { Polygon.new([0,0], [1,0], [1,1], [0,1]) }
  let(:simple_concave) { Polygon.new([0,0], [4,0], [4,2], [3,2], [3,1], [1,1], [1,2], [0,2]) }
  subject { unit_square }

  it "must create a Polygon object with no arguments" do
    polygon = Geometry::Polygon.new
    assert_kind_of(Geometry::Polygon, polygon)
    assert_equal(0, polygon.edges.size)
    assert_equal(0, polygon.vertices.size)
  end

  it "must create a Polygon object from array arguments" do
    polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1])
    assert_kind_of(Geometry::Polygon, polygon)
    assert_equal(4, polygon.edges.size)
    assert_equal(4, polygon.vertices.size)
  end

  describe "when creating a Polygon from an array of Points" do
    it "must ignore repeated Points" do
      polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [1,1], [0,1])
      assert_kind_of Geometry::Polygon, polygon
      assert_equal polygon.edges.size, 4
      assert_equal polygon.vertices.size, 4
      assert_equal polygon, Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1])
    end

    it "must collapse collinear Edges" do
      polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [0.5,1], [0,1])
      assert_equal polygon, Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1])
    end

    it "must collapse backtracking Edges" do
      polygon = Geometry::Polygon.new([0,0], [2,0], [2,2], [1,2], [1,1], [1,2], [0,2])
      assert_equal polygon, Geometry::Polygon.new([0,0], [2,0], [2,2], [0,2])
    end
  end

  it "must compare identical polygons as equal" do
    assert unit_square.eql? unit_square
  end

  it "must create closed polygons" do
    assert subject.closed?
  end

  it "must handle already closed polygons" do
    polygon = Geometry::Polygon.new([0,0], [1,0], [1,1], [0,1], [0,0])
    assert_kind_of(Geometry::Polygon, polygon)
    assert_equal(4, polygon.edges.size)
    assert_equal(4, polygon.vertices.size)
    assert_equal(polygon.edges.first.first, polygon.edges.last.last)
  end

  it "must return itself on close" do
    closed = subject.close
    assert closed.closed?
    assert_equal closed, subject
    _(closed).must_be_same_as subject
  end

  describe "orientation" do
    it "must return true for clockwise" do
      assert Polygon.new([0,0], [0,1], [1,1], [1,0]).clockwise?
      assert Polygon.new([1,1], [1,3], [3,3], [3,1]).clockwise?
    end

    it "must return false for counterclockwise" do
      refute Polygon.new([0,0], [1,0], [1,1], [0,1]).clockwise?
      refute Polygon.new([1,1], [3,1], [3,3], [1,3]).clockwise?
    end
  end

  it "must gift wrap a square polygon" do
    polygon = Polygon.new([0,0], [1,0], [1,1], [0,1])
    convex_hull = polygon.wrap
    assert_kind_of Geometry::Polygon, convex_hull
    assert_equal convex_hull.edges.size, 4
    assert_equal convex_hull.vertices, [[0,0], [0,1], [1,1], [1,0]].map {|a| Point[*a]}
  end

  it "must gift wrap another square polygon" do
    polygon = Polygon.new([0,1], [0,0], [1,0], [1,1])
    convex_hull = polygon.wrap
    assert_kind_of Geometry::Polygon, convex_hull
    assert_equal convex_hull.edges.size, 4
    assert_equal convex_hull.vertices, [[0,0], [0,1], [1,1], [1,0]].map {|a| Point[*a]}
  end

  it "must gift wrap a concave polygon" do
    polygon = Polygon.new([0,0], [1,-1], [2,0], [1,1], [2,2], [0,1])
    convex_hull = polygon.wrap
    assert_kind_of Geometry::Polygon, convex_hull
    assert_equal convex_hull.edges.size, 5
    assert_equal convex_hull.vertices, [Point[0, 0], Point[0, 1], Point[2, 2], Point[2, 0], Point[1, -1]]
  end

  it "must gift wrap a polygon" do
    polygon = Polygon.new([0,0], [1,-1], [2,0], [2,1], [0,1])
    convex_hull = polygon.wrap
    assert_kind_of Geometry::Polygon, convex_hull
    assert_equal convex_hull.edges.size, 5
    assert_equal convex_hull.vertices, [[0,0], [0,1], [2,1], [2,0], [1,-1]].map {|a| Point[*a]}
  end

  it "must generate spokes" do
    assert_equal unit_square.spokes, [Vector[-1,-1], Vector[1,-1], Vector[1,1], Vector[-1,1]]
    assert_equal cw_unit_square.spokes, [Vector[-1,-1], Vector[-1,1], Vector[1,1], Vector[1,-1]]
    assert_equal simple_concave.spokes, [Vector[-1,-1], Vector[1,-1], Vector[1,1], Vector[-1,1], Vector[-1,1], Vector[1,1], Vector[1,1], Vector[-1,1]]
  end

  describe "spaceship" do
    it "with a Point" do
      assert_equal unit_square <=> Point[2,0], -1
      assert_equal unit_square <=> Point[1,0], 0
      assert_equal unit_square <=> Point[0.5,0.5], 1
    end

    it "with a Point that lies on a horizontal edge" do
      assert_equal unit_square <=> Point[0.5,0], 0
    end
  end

  describe "when outsetting" do
    it "must outset a unit square" do
      outset_polygon = unit_square.outset(1)
      expected_polygon = Polygon.new([-1.0,-1.0], [2.0,-1.0], [2.0,2.0], [-1.0,2.0])
      assert_equal outset_polygon, expected_polygon
    end

    it "must outset a simple concave polygon" do
      concave_polygon = Polygon.new([0,0], [4,0], [4,2], [3,2], [3,1], [1,1], [1,2], [0,2])
      outset_polygon = concave_polygon.outset(1)
      assert_equal outset_polygon, Polygon.new([-1,-1], [5,-1], [5,3], [-1,3])
    end

    it "must outset a concave polygon" do
      concave_polygon = Polygon.new([0,0], [4,0], [4,2], [3,2], [3,1], [1,1], [1,2], [0,2])
      outset_polygon = concave_polygon.outset(2)
      assert_equal outset_polygon, Polygon.new([-2,-2], [6,-2], [6,4], [-2,4])
    end

    it "must outset an asymetric concave polygon" do
      concave_polygon = Polygon.new([0,0], [4,0], [4,3], [3,3], [3,1], [1,1], [1,2], [0,2])
      outset_polygon = concave_polygon.outset(2)
      assert_equal outset_polygon, Polygon.new([-2,-2], [6,-2], [6,5], [1,5], [1,4], [-2,4])
    end

    it "must outset a concave polygon with multiply-intersecting edges" do
      concave_polygon = Polygon.new([0,0], [5,0], [5,2], [4,2], [4,1], [3,1], [3,2], [2,2], [2,1], [1,1], [1,2], [0,2])
      outset_polygon = concave_polygon.outset(1)
      assert_equal outset_polygon, Polygon.new([-1,-1], [6,-1], [6,3], [-1,3])
    end

    it "must outset a concave polygon where the first outset edge intersects with the last outset edge" do
      polygon = Polygon.new([0,0], [0,1], [2,1], [2,2], [-1,2], [-1,-1], [2,-1], [2,0])
      assert_equal polygon.edges.count, 8
      assert_equal polygon.outset(1), Polygon.new([3, 0], [3, 3], [-2, 3], [-2, -2], [3, -2])
    end

    # Naturally, this test is very sensitive to the input coordinate values. This is a painfully contrived example that
    #  checks for sensitivity to edges that are very close to horizontal, but not quite.
    # When the test fails, the first point of the offset polygon is at [0,-1]
    it "must not be sensitive to floating point rounding errors" do
      polygon = Polygon.new([0, 0], [0, -2], [10, -2], [10, 10], [-100, 10], [-100, -22], [-69, -22], [-69, 3.552713678800501e-15], [0,0])
      outset = polygon.outset(1)
      assert_equal outset.edges.first.first, Geometry::Point[-1,-1]
    end
  end

  describe "set operations" do
    describe "union" do
      it "must union two adjacent squares" do
        polygonA = Polygon.new([0,0], [1,0], [1,1], [0,1])
        polygonB = Polygon.new([1,0], [2,0], [2,1], [1,1])
        assert_equal polygonA.union(polygonB), Polygon.new([0,0], [2,0], [2,1], [0,1])
        assert_equal polygonA + polygonB, Polygon.new([0,0], [2,0], [2,1], [0,1])
      end

      it "must union two overlapping squares" do
        polygonA = Polygon.new([0,0], [2,0], [2,2], [0,2])
        polygonB = Polygon.new([1,1], [3,1], [3,3], [1,3])
        expected_polygon = Polygon.new([0,0], [2,0], [2,1], [3,1], [3,3], [1,3], [1,2], [0,2])
        union = polygonA.union polygonB
        assert_kind_of Polygon, union
        assert_equal union, expected_polygon
      end

      it "must union two overlapping clockwise squares" do
        polygonA = Polygon.new([0,0], [0,2], [2,2], [2,0])
        polygonB = Polygon.new([1,1], [1,3], [3,3], [3,1])
        expected_polygon = Polygon.new([0, 0], [0, 2], [1, 2], [1, 3], [3, 3], [3, 1], [2, 1], [2, 0])
        union = polygonA.union polygonB
        assert_kind_of Polygon, union
        assert_equal union, expected_polygon
      end

      it "must union two overlapping squares with collinear edges" do
        polygonA = Polygon.new([0,0], [2,0], [2,2], [0,2])
        polygonB = Polygon.new([1,0], [3,0], [3,2], [1,2])
        union = polygonA + polygonB
        assert_kind_of Polygon, union
        assert_equal union, Polygon.new([0,0], [3,0], [3,2], [0,2])
      end
    end
  end
end
