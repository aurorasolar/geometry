require 'minitest/autorun'
require 'geometry/polyline'

describe Geometry::Polyline do
  Polyline = Geometry::Polyline

  let(:closed_unit_square) { Polyline.new([0,0], [1,0], [1,1], [0,1], [0,0]) }
  let(:unit_square) { Polyline.new([0,0], [1,0], [1,1], [0,1]) }
  let(:reverse_unit_square)	{ Polyline.new([0,1], [1,1], [1,0], [0,0]) }

  it "must create a Polyline object with no arguments" do
    polyline = Geometry::Polyline.new
    assert_kind_of Polyline, polyline
    assert_equal polyline.edges.count, 0
    assert_equal polyline.vertices.count, 0
  end

  it "must create a Polyline object from array arguments" do
    polyline = Geometry::Polyline.new([0,0], [1,0], [1,1], [0,1])
    assert_kind_of Polyline, polyline
    assert_equal polyline.edges.count, 3
    assert_equal polyline.vertices.count, 4
  end

  describe "when the Polyline is closed" do
    let(:closed_concave_polyline) { Polyline.new([-2,0], [0,0], [0,-2], [2,-2], [2,2], [-2,2], [-2,0]) }
    subject { closed_concave_polyline }

    it "must be closed" do
      assert closed_unit_square.closed?
    end

    it "must clone and close" do
      closed = subject.close
      assert closed.closed?
      assert_equal closed, subject
      _(closed).wont_be_same_as subject
    end

    it "must be able to close itself" do
      subject.close!
      assert subject.closed?
      assert_equal subject, subject
    end

    it "must clone and reverse" do
      vertices = subject.vertices
      vertices.push vertices.shift
      reversed = subject.reverse
      assert_equal reversed.vertices, vertices.reverse
      _(reversed).wont_be_same_as subject
      assert reversed.closed?
    end

    it "must reverse itself" do
      original = subject.vertices.dup
      subject.reverse!
      assert_equal subject.vertices.to_a, original.reverse
      assert subject.closed?
    end

    it "must generate bisectors" do
      assert_equal closed_unit_square.bisectors, [Vector[1, 1], Vector[-1, 1], Vector[-1, -1], Vector[1, -1]]
    end

    it "must generate bisectors with an inside corner" do
      assert_equal closed_concave_polyline.bisectors, [Vector[1,1], Vector[-1,-1], Vector[1,1], Vector[-1,1], Vector[-1,-1], Vector[1,-1]]
    end

    it "must generate left bisectors" do
      assert_equal closed_unit_square.left_bisectors, [Vector[1, 1], Vector[-1, 1], Vector[-1, -1], Vector[1, -1]]
    end

    it "must generate left bisectors with an inside corner" do
      assert_equal closed_concave_polyline.left_bisectors, [Vector[1,1], Vector[1,1], Vector[1,1], Vector[-1,1], Vector[-1,-1], Vector[1,-1]]
    end

    it "must generate right bisectors" do
      assert_equal closed_unit_square.right_bisectors, [Vector[-1,-1], Vector[1,-1], Vector[1,1], Vector[-1,1]]
    end

    it "must generate right bisectors with an inside corner" do
      assert_equal closed_concave_polyline.right_bisectors, [Vector[-1,-1], Vector[-1,-1], Vector[-1,-1], Vector[1,-1], Vector[1,1], Vector[-1,1]]
    end

    it "must generate spokes" do
      assert_equal closed_unit_square.spokes, [Vector[-1,-1], Vector[1,-1], Vector[1,1], Vector[-1,1]]
    end

    it "must rightset a closed concave polyline where the first outset edge intersects with the last outset edge" do
      skip
      polyline = Polyline.new([0,0], [0,1], [2,1], [2,2], [-1,2], [-1,-1], [2,-1], [2,0], [0,0])
      assert_equal polyline.offset(-1), Polyline.new([1, 0], [3, 0], [3, 3], [-2, 3], [-2, -2], [3, -2])
    end
  end

  describe "when the Polyline is open" do
    let(:concave_polyline) { Polyline.new([-2,0], [0,0], [0,-2], [2,-2], [2,2], [-2,2]) }
    subject { concave_polyline }

    it "must not be closed" do
      refute unit_square.closed?
    end

    it "must clone and close" do
      closed = subject.close
      assert closed.closed?
      assert_equal closed, subject
      _(closed).wont_be_same_as subject
    end

    it "must be able to close it" do
      closed = subject.close!
      assert closed.closed?
      assert_equal closed, subject
      _(closed).must_be_same_as subject
    end

    it "must clone and reverse" do
      reversed = subject.reverse
      assert_equal reversed.vertices, subject.vertices.reverse
      _(reversed).wont_be_same_as subject
      refute reversed.closed?
    end

    it "must reverse itself" do
      original = subject.vertices.dup
      subject.reverse!
      assert_equal subject.vertices.to_a, original.reverse
      refute subject.closed?
    end

    it "must generate bisectors" do
      assert_equal unit_square.bisectors, [Vector[0, 1], Vector[-1, 1], Vector[-1, -1], Vector[0, -1]]
    end

    it "must generate bisectors with an inside corner" do
      assert_equal concave_polyline.bisectors, [Vector[0,1], Vector[-1,-1], Vector[1,1], Vector[-1,1], Vector[-1,-1], Vector[0,-1]]
    end

    it "must generate left bisectors" do
      assert_equal unit_square.left_bisectors, [Vector[0, 1], Vector[-1, 1], Vector[-1, -1], Vector[0, -1]]
      assert_equal reverse_unit_square.left_bisectors, [Vector[0, 1], Vector[1, 1], Vector[1, -1], Vector[0, -1]]
    end

    it "must generate right bisectors" do
      assert_equal unit_square.right_bisectors, [Vector[0,-1], Vector[1,-1], Vector[1,1], Vector[0,1]]
    end

    it "must generate right bisectors with an inside corner" do
      assert_equal concave_polyline.right_bisectors, [Vector[0,-1], Vector[-1,-1], Vector[-1,-1], Vector[1,-1], Vector[1,1], Vector[0,1]]
    end

    it "must generate left bisectors with an inside corner" do
      assert_equal concave_polyline.left_bisectors, [Vector[0,1], Vector[1,1], Vector[1,1], Vector[-1,1], Vector[-1,-1], Vector[0,-1]]
    end

    it "must generate spokes" do
      assert_equal unit_square.spokes, [Vector[0,-1], Vector[1,-1], Vector[1,1], Vector[0,1]]
    end
  end

  describe "when checking for closedness" do
    it "must be closed when it is closed" do
      assert closed_unit_square.closed?
    end

    it "must not be closed when it is not closed" do
      refute unit_square.closed?
    end
  end

  describe "when creating a Polyline from an array of Points" do
    it "must ignore repeated Points" do
      polyline = Geometry::Polyline.new([0,0], [1,0], [1,1], [1,1], [0,1])
      assert_kind_of Geometry::Polyline, polyline
      assert_equal polyline, Geometry::Polyline.new([0,0], [1,0], [1,1], [0,1])
    end

    it "must collapse collinear Edges" do
      polyline = Geometry::Polyline.new([0,0], [1,0], [1,1], [0.5,1], [0,1])
      assert_equal polyline, Geometry::Polyline.new([0,0], [1,0], [1,1], [0,1])
    end

    it "must collapse backtracking Edges" do
      polyline = Geometry::Polyline.new([0,0], [2,0], [2,2], [1,2], [1,1], [1,2], [0,2])
      assert_equal polyline, Geometry::Polyline.new([0,0], [2,0], [2,2], [0,2]) end
  end

  it "must compare identical polylines as equal" do
    assert unit_square.eql? unit_square
  end

  it "must rightset a closed concave polyline where the first outset edge intersects with the last outset edge" do
    skip
    polyline = Polyline.new([0,0], [0,1], [2,1], [2,2], [-1,2], [-1,-1], [2,-1], [2,0], [0,0])
    assert_equal polyline.offset(-1), Polyline.new([1, 0], [3, 0], [3, 3], [-2, 3], [-2, -2], [3, -2])
  end

  describe "when offsetting" do
    describe "with a positive offset" do
      it "must leftset a unit square" do
        expected_polyline = Polyline.new([0,0.1], [0.9,0.1], [0.9,0.9], [0,0.9])
        assert_equal unit_square.offset(0.1), expected_polyline
      end

      it "must leftset a simple concave polyline" do
        concave_polyline = Polyline.new([0,0], [4,0], [4,4], [3,4], [3,3], [1,3], [1,4], [0,4])
        offset_polyline = concave_polyline.offset(1)
        assert_equal offset_polyline, Polyline.new([0,1], [3,1], [3,2], [0,2], [0,3])
      end
    end

    describe "with a negative offset" do
      it "must rightset a unit square" do
        expected_polyline = Polyline.new([0,-1.0], [2.0,-1.0], [2.0,2.0], [0,2.0])
        assert_equal unit_square.offset(-1), expected_polyline
      end

      it "must rightset a simple concave polyline" do
        concave_polyline = Polyline.new([0,0], [4,0], [4,2], [3,2], [3,1], [1,1], [1,2], [0,2])
        offset_polyline = concave_polyline.offset(-1)
        assert_equal offset_polyline, Polyline.new([0,-1], [5,-1], [5,3], [0,3])
      end

      it "must rightset a concave polyline" do
        concave_polyline = Polyline.new([0,0], [4,0], [4,2], [3,2], [3,1], [1,1], [1,2], [0,2])
        offset_polyline = concave_polyline.offset(-2)
        assert_equal offset_polyline, Polyline.new([0,-2], [6,-2], [6,4], [0,4])
      end

      it "must rightset an asymetric concave polyline" do
        concave_polyline = Polyline.new([0,0], [4,0], [4,3], [3,3], [3,1], [1,1], [1,2], [0,2])
        offset_polyline = concave_polyline.offset(-2)
        assert_equal offset_polyline, Polyline.new([0,-2], [6,-2], [6,5], [1,5], [1,4], [0,4])
      end

      it "must rightset a concave polyline with multiply-intersecting edges" do
        concave_polyline = Polyline.new([0,0], [5,0], [5,2], [4,2], [4,1], [3,1], [3,2], [2,2], [2,1], [1,1], [1,2], [0,2])
        offset_polyline = concave_polyline.offset(-2)
        assert_equal offset_polyline, Polyline.new([0,-2], [7,-2], [7,4], [0,4])
      end

      it "must rightset a closed concave polyline with multiply-intersecting edges" do
        concave_polyline = Polyline.new([0,0], [5,0], [5,2], [4,2], [4,1], [3,1], [3,2], [2,2], [2,1], [1,1], [1,2], [0,2], [0,0])
        offset_polyline = concave_polyline.offset(-2)
        assert_equal offset_polyline, Polyline.new([-2,-2], [7,-2], [7,4], [-2,4])
      end

      it "must rightset a concave polyline where the first outset edge intersects with the last outset edge" do
        polyline = Polyline.new([0,0], [0,1], [2,1], [2,2], [-1,2], [-1,-1], [2,-1], [2,0])
        assert_equal polyline.offset(-1), Polyline.new([1, 0], [3, 0], [3, 3], [-2, 3], [-2, -2], [3, -2])
      end

      # Naturally, this test is very sensitive to the input coordinate values. This is a painfully contrived example that
      #  checks for sensitivity to edges that are very close to horizontal, but not quite.
      # When the test fails, the first point of the offset polyline is at [0,-1]
      it "must not be sensitive to floating point rounding errors" do
        polyline = Polyline.new([0, 0], [0, -2], [10, -2], [10, 10], [-100, 10], [-100, -22], [-69, -22], [-69, 3.552713678800501e-15], [0,0])
        outset = polyline.offset(-1)
        assert_equal outset.edges.first.first, Geometry::Point[-1,-1]
      end
    end
  end
end
