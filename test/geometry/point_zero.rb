require 'minitest/autorun'
require 'geometry/point_zero'

describe Geometry::PointZero do
  let(:zero) { Geometry::PointZero.new }

  describe "arithmetic" do
    let(:left) { Point[1,2] }
    let(:right) { Point[3,4] }

    it "must have +@" do
      assert_equal +zero, 0
      assert_instance_of Geometry::PointZero, +zero
    end

    it "must have unary negation" do
      assert_equal -zero, 0
      assert_instance_of Geometry::PointZero, -zero
    end

    describe "Accessors" do
      it "must return 0 for array access" do
        assert_equal zero[3], 0
      end

      it "must return 0 for named element access" do
        assert_equal zero.x, 0
        assert_equal zero.y, 0
        assert_equal zero.z, 0
      end
    end

    describe "when adding" do
      it "must return a number" do
        assert_equal zero + 3, 3
        assert_equal 3 + zero, 3
      end

      it "return a Point when adding two Points" do
        assert_kind_of Point, zero + right
        assert_kind_of Point, left + zero
      end

      it "must return an Array when adding an array" do
        assert_equal zero + [5,6], [5,6]
        #		([5,6] + zero).must_equal [5,6]
      end

      it "must return a Point when adding a Size" do
        assert_instance_of Point, zero + Size[5,6]
        assert_equal zero + Size[5,6], Point[5,6]
      end
    end

    describe "when subtracting" do
      it "must return a number" do
        assert_equal zero - 3, -3
        assert_equal 3 - zero, 3
      end

      it "return a Point when subtracting two Points" do
        assert_equal zero - right, Point[-3,-4]
        assert_equal left - zero, Point[1,2]
      end

      it "must return a Point when subtracting an array" do
        assert_equal zero - [5,6], [-5, -6]
        #		([5,6] - zero).must_equal [5,6]
      end

      it "must return a Point when subtracting a Size" do
        _(zero - Size[5,6]).must_be_instance_of(Point)
        assert_equal zero - Size[5,6], Point[-5,-6]
      end
    end

    describe "multiplication" do
      it "must return 0 for scalars" do
        assert_equal zero * 3, 0
        assert_equal zero * 3.0, 0.0
      end

      it "must return 0 for Points" do
        assert_equal zero * Point[1,2], 0
      end

      it "must return 0 for Vectors" do
        assert_equal zero * Vector[2,3], 0
      end
    end

    describe "division" do
      it "must return 0 for non-zero scalars" do
        assert_equal zero / 3, 0
        assert_equal zero / 4.0, 0
      end

      it "must raise an exception when divided by 0" do
        assert_raises(ZeroDivisionError) { zero / 0 }
      end

      it "must raise an exception for Points" do
        assert_raises(Geometry::OperationNotDefined) { zero / Point[1,2] }
      end

      it "must raise an exception for Vectors" do
        assert_raises(Geometry::OperationNotDefined) { zero / Vector[1,2] }
      end

    end

  end

  describe "coercion" do
    it "must coerce Arrays into Points" do
      assert_equal [Point[3,4], Point[0,0]], zero.coerce([3,4])
    end

    it "must coerce Vectors into Vectors" do
      assert_equal zero.coerce(Vector[3,4]), [Vector[3,4], Vector[0,0]]
    end

    it "must coerce Points into Points" do
      assert_equal zero.coerce(Point[5,6]), [Point[5,6], Point[0,0]]
    end
  end

  describe "comparison" do
    subject { Geometry::PointZero.new }

    it "must be equal to 0 and 0.0" do
      _(zero).must_be :eql?, 0
      _(zero).must_be :eql?, 0.0
    end

    it "must not be equal to a non-zero number" do
      refute_equal 1, zero
      refute_equal 3.14, zero
    end

    it "must be equal to an Array of zeros" do
      _(zero).must_be :==, [0,0]
      _(zero).must_be :eql?, [0,0]
      _(zero).must_be :===, [0,0]
      assert_equal [0,0], zero
      assert_equal subject, [0,0]
    end

    it "must not be equal to a non-zero Array" do
      refute_equal zero, [3,2]
      refute_equal [3,2], zero
    end

    it "must be equal to a Point at the origin" do
      _(zero).must_be :==, Point[0,0]
      _(zero).must_be :eql?, Point[0,0]
      _(zero).must_be :===, Point[0,0]
      assert_equal Point[0,0], zero
      assert_equal subject, Point[0,0]
    end

    it "must not be equal to a Point not at the origin" do
      refute_equal zero, Point[3,2]
      refute_equal Point[3,2], zero
    end

    it "must be equal to an Vector of zeroes" do
      _(zero).must_be :eql?, Vector[0,0]
      assert_equal zero, Vector[0,0]
    end

    it "must not be equal to a non-zero Vector" do
      refute_equal zero, Vector[3,2]
      refute_equal Vector[3,2], zero
    end
  end
end
