require 'minitest/autorun'
require 'geometry/regular_polygon'

describe Geometry::RegularPolygon do
  RegularPolygon = Geometry::RegularPolygon

  describe "when constructed with named center and radius arguments" do
    let(:polygon) { RegularPolygon.new(sides:4, center:[1,2], radius:3) }
    subject { RegularPolygon.new(sides:4, center:[1,2], radius:3) }

    it "must create a RegularPolygon" do
      _(polygon).must_be_instance_of(RegularPolygon)
    end

    it "must have the correct number of sides" do
      assert_equal polygon.edge_count, 4
    end

    it "must have a center point accessor" do
      assert_equal polygon.center, Point[1,2]
    end

    it "must have a radius accessor" do
      assert_equal polygon.radius, 3
    end

    it "must compare equal" do
      assert_equal polygon, RegularPolygon.new(sides:4, center:[1,2], radius:3)
    end

    describe "properties" do
      it "must have vertices" do
        assert_equal subject.vertices, [Point[4.0, 2.0], Point[1.0000000000000002, 5.0], Point[-2.0, 2.0000000000000004], Point[0.9999999999999994, -1.0]]
      end
    end
  end

  describe "when constructed with a center and diameter" do
    let(:polygon) { RegularPolygon.new(sides:4, center:[1,2], diameter:4) }

    it "must be a DiameterRegularPolygon" do
      _(polygon).must_be_instance_of(Geometry::DiameterRegularPolygon)
      assert_kind_of RegularPolygon, polygon
    end

    it "must have the correct number of sides" do
      assert_equal polygon.edge_count, 4
    end

    it "must have a center" do
      assert_equal polygon.center, Point[1,2]
    end

    it "must have a diameter" do
      assert_equal polygon.diameter, 4
    end

    it "must calculate the correct radius" do
      assert_equal polygon.radius, 2
    end

    it "must compare equal" do
      assert_equal polygon, RegularPolygon.new(sides:4, center:[1,2], diameter:4)
    end
  end

  describe "when constructed with a diameter and no center" do
    let(:polygon) { RegularPolygon.new(sides:4, diameter:4) }

    it "must be a DiameterRegularPolygon" do
      _(polygon).must_be_instance_of(Geometry::DiameterRegularPolygon)
      assert_kind_of RegularPolygon, polygon
    end

    it "must have the correct number of sides" do
      assert_equal polygon.edge_count, 4
    end

    it "must be at the origin" do
      assert_equal polygon.center, Point.zero
    end

    it "must have a diameter" do
      assert_equal polygon.diameter, 4
    end

    it "must calculate the correct radius" do
      assert_equal polygon.radius, 2
    end
  end

  describe "properties" do
    subject { RegularPolygon.new(sides:6, diameter:4) }

    it "must have edges" do
      expected_edges = [Edge(Point[2, 0], Point[1, 1.732]), Edge(Point[1, 1.732], Point[-1, 1.732]), Edge(Point[-1, 1.732], Point[-2, 0]), Edge(Point[-2, 0], Point[-1, -1.732]), Edge(Point[-1, -1.732], Point[1, -1.732]), Edge(Point[1, -1.732], Point[2, 0])]
      subject.edges.zip(expected_edges) do |edge1, edge2|
        edge1.to_a.zip(edge2.to_a) do |point1, point2|
          point1.to_a.zip(point2.to_a) {|a, b| assert_in_delta(a, b, 0.0001) }
        end
      end
    end

    it "must have a bounds property that returns a Rectangle" do
      assert_equal subject.bounds, Rectangle.new([-2,-2], [2,2])
    end

    it "must have a minmax property that returns the corners of the bounding rectangle" do
      assert_equal subject.minmax, [Point[-2,-2], Point[2,2]]
    end

    it "must have a max property that returns the upper right corner of the bounding rectangle" do
      assert_equal subject.max, Point[2,2]
    end

    it "must have a min property that returns the lower left corner of the bounding rectangle" do
      assert_equal subject.min, Point[-2,-2]
    end
  end
end
