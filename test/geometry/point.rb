require 'minitest/autorun'
require 'geometry/point'

describe Geometry::Point do
  PointZero = Geometry::PointZero

  describe "class methods" do
    it "must generate a PointZero" do
      _(Point.zero).must_be_instance_of(PointZero)
    end

    it "must generate a Point full of zeros" do
      assert_equal Point.zero(3), Point[0,0,0]
    end
  end

  describe "constructor" do
    it "must return the Point when constructed from a Point" do
      original_point = Point[3,4]
      point = Geometry::Point[original_point]
      _(point).must_be_same_as original_point
      assert_equal point.size, 2
      assert_equal point.x, 3
      assert_equal point.y, 4
    end

    it "must return the PointZero when constructed from a PointZero" do
      original_point = Geometry::PointZero.new
      point = Geometry::Point[original_point]
      _(point).must_be_same_as original_point
    end
  end

  it "create a Point object from an array" do
    point = Geometry::Point[[3,4]]
    assert_equal(2, point.size)
    assert_equal(3, point.x)
    assert_equal(4, point.y)
  end
  it "create a Point object from individual parameters" do
    point = Geometry::Point[3,4]
    assert_equal(2, point.size)
    assert_equal(3, point.x)
    assert_equal(4, point.y)
  end
  it "create a Point object from a Vector" do
    point = Geometry::Point[Vector[3,4]]
    assert_equal(2, point.size)
    assert_equal(3, point.x)
    assert_equal(4, point.y)
  end

  it "create a Point object from a Point using list syntax" do
    point = Geometry::Point[Geometry::Point[13,14]]
    assert_equal(2, point.size)
    assert_equal(13, point.x)
    assert_equal(14, point.y)
  end
  it "allow indexed element access" do
    point = Geometry::Point[5,6]
    assert_equal(2, point.size)
    assert_equal(5, point[0])
    assert_equal(6, point[1])
  end
  it "allow named element access" do
    point = Geometry::Point[5,6,7]
    assert_equal(3, point.size)
    assert_equal(5, point.x)
    assert_equal(6, point.y)
    assert_equal(7, point.z)
  end

  it "implement inspect" do
    point = Geometry::Point[8,9]
    assert_equal('Point[8, 9]', point.inspect)
  end
  it "implement to_s" do
    point = Geometry::Point[10,11]
    assert_equal('Point[10, 11]', point.to_s)
  end

  it "must support array access" do
    assert_equal Point[1,2][0], 1
    assert_equal Point[1,2][1], 2
    assert_nil Point[1,2][2]
  end

  it "must clone" do
    _(Point[1,2].clone).must_be_instance_of(Point)
    assert_equal Point[1,2].clone, Point[1,2]
  end

  it "must duplicate" do
    _(Point[1,2].dup).must_be_instance_of(Point)
    assert_equal Point[1,2].dup, Point[1,2]
  end

  describe "arithmetic" do
    let(:left) { Point[1,2] }
    let(:right) { Point[3,4] }

    it "must have +@" do
      assert_equal +left, Point[1,2]
      _(+left).must_be_instance_of(Point)
    end

    it "must have unary negation" do
      assert_equal -left, Point[-1,-2]
      _(-left).must_be_instance_of(Point)
    end

    describe "when adding" do
      it "return a Point when adding two Points" do
        assert_kind_of(Point, left+right)
      end

      it "must return a Point when adding an array to a Point" do
        assert_equal left + [5,6], Point[6,8]
      end

      it "must add a Numeric to all elements" do
        assert_equal left + 2, Point[3,4]
        assert_equal 2 + left, Point[3,4]
      end

      it "must raise an exception when adding mismatched sizes" do
        assert_raises(Geometry::DimensionMismatch) { left + [1,2,3,4] }
      end

      it "must return a Point when adding a Vector" do
        assert_equal left + Vector[5,6], Point[6,8]
        assert_equal Vector[5,6] + right, Vector[8,10]
      end

      it "must return self when adding a PointZero" do
        assert_equal left + Point.zero, left
      end

      it "must return self when adding a NilClass" do
        assert_equal left + nil, left
      end
    end

    describe "when subtracting" do
      it "return a Point when subtracting two Points" do
        assert_kind_of(Point, left-right)
      end

      it "must return a Point when subtracting an array from a Point" do
        assert_equal left - [5,6], Point[-4, -4]
      end

      it "must subtract a Numeric from all elements" do
        assert_equal left - 2, Point[-1, 0]
        assert_equal 2 - left, Point[1,0]
      end

      it "must raise an exception when subtracting mismatched sizes" do
        assert_raises(Geometry::DimensionMismatch) { left - [1,2,3,4] }
      end

      it "must return self when subtracting a PointZero" do
        assert_equal left - Point.zero, left
      end

      it "must return self when subtracting a NilClass" do
        assert_equal left - nil, left
      end
    end

    describe "when multiplying" do
      it "must return a Point when multiplied by a Matrix" do
        assert_equal Matrix[[1,2],[3,4]]*Point[5,6], Point[17, 39]
      end
    end
  end

  describe "coercion" do
    subject { Point[1,2] }

    it "must coerce Arrays into Points" do
      assert_equal subject.coerce([3,4]), [Point[3,4], subject]
    end

    it "must coerce Vectors into Points" do
      assert_equal subject.coerce(Vector[3,4]), [Point[3,4], subject]
    end

    it "must coerce a Numeric into a Point" do
      assert_equal subject.coerce(42), [Point[42,42], subject]
    end

    it "must reject anything that can't be coerced" do
      assert_raises(TypeError) { subject.coerce(NilClass) }
    end
  end

  describe "comparison" do
    let(:point) { Point[1,2] }

    it "must compare equal to an equal Array" do
      assert point == [1,2]
      assert point.eql?([1,2])
      _(point).must_be :==, [1,2]
      _(point).must_be :eql?, [1,2]
      assert_equal point, [1,2]
    end

    it "must not compare equal to an unequal Array" do
      refute_equal point, [3,2]
      refute_equal [3,2], point
    end

    it "must compare equal to an equal Point" do
      _(point).must_be :==, Point[1,2]
      _(point).must_be :eql?, Point[1,2]
      assert_equal Point[1,2], point
    end

    it "must not compare equal to an unequal Point" do
      refute_equal point, Point[3,2]
      refute_equal Point[3,2], point
    end

    it "must compare equal to an equal Vector" do
      assert_equal point, Vector[1,2]
      assert_equal Vector[1,2], point
    end

    it "must not compare equal to an unequal Vector" do
      refute_equal point, Vector[3,2]
      refute_equal Vector[3,2], point
    end

    it "must think that floats == ints" do
      _(Point[1,2]).must_be :==, Point[1.0,2.0]
      _(Point[1.0,2.0]).must_be :==, Point[1,2]
    end

    it "must not think that floats eql? ints" do
      _(Point[1,2]).wont_be :eql?, Point[1.0,2.0]
      _(Point[1.0,2.0]).wont_be :eql?, Point[1,2]
    end

    describe "spaceship" do
      it "must spaceship with another Point of the same length" do
        assert_equal Point[1,2] <=> Point[0,3], Point[1,-1]
      end

      it "must spaceship with another Point of different length" do
        assert_equal Point[1,2] <=> Point[0,3,4], Point[1,-1]
        assert_equal Point[1,2,4] <=> Point[0,3], Point[1,-1]
      end

      it "must spaceship with an Array" do
        assert_equal Point[1,2] <=> [0,3], Point[1,-1]
      end
    end
  end
end
