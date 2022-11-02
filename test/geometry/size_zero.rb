require 'minitest/autorun'
require 'geometry/size_zero'

describe Geometry::SizeZero do
  Size = Geometry::Size

  let(:zero) { Geometry::SizeZero.new }

  describe "arithmetic" do
    let(:left) { Size[1,2] }
    let(:right) { Size[3,4] }

    it "must have +@" do
      _(+zero).must_be :eql?, 0
      _(+zero).must_be_instance_of(Geometry::SizeZero)
    end

    it "must have unary negation" do
      _(-zero).must_be :eql?, 0
      _(-zero).must_be_instance_of(Geometry::SizeZero)
    end

    describe "when adding" do
      it "must return a number" do
        assert_equal zero + 3, 3
        assert_equal 3 + zero, 3
      end

      it "return a Size when adding two Sizes" do
        assert_kind_of Size, zero + right
        #		(left + zero).must_be_kind_of Size
      end

      it "must return a Size when adding an array" do
        assert_equal zero + [5,6], [5,6]
        #		([5,6] + zero).must_equal [5,6]
      end
    end

    describe "when subtracting" do
      it "must return a number" do
        assert_equal zero - 3, -3
        assert_equal 3 - zero, 3
      end

      it "return a Size when subtracting two Size" do
        assert_equal zero - right, Size[-3,-4]
        assert_equal left - zero, Size[1,2]
      end

      it "must return a Size when subtracting an array" do
        assert_equal zero - [5,6], [-5, -6]
        #		([5,6] - zero).must_equal [5,6]
      end
    end

    describe "multiplication" do
      it "must return 0 for scalars" do
        assert_equal zero * 3, 0
        assert_equal zero * 3.0, 0.0
      end

      it "must return 0 for Sizes" do
        assert_equal zero * Size[1,2], 0
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

      it "must raise an exception for Sizes" do
        assert_raises(Geometry::OperationNotDefined) { zero / Size[1,2] }
      end

      it "must raise an exception for Vectors" do
        assert_raises(Geometry::OperationNotDefined) { zero / Vector[1,2] }
      end

    end

  end

  describe "coercion" do
    it "must coerce Arrays into Sizes" do
      assert_equal [Size[3,4], Size[0,0]], zero.coerce([3,4])
    end

    it "must coerce Vectors into Vectors" do
      assert_equal zero.coerce(Vector[3,4]), [Vector[3,4], Vector[0,0]]
    end

    it "must coerce Size into Size" do
      assert_equal zero.coerce(Size[5,6]), [Size[5,6], Size[0,0]]
    end
  end

  describe "comparison" do
    let(:zero) { Geometry::PointZero.new }

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
      assert_equal [0,0], zero
    end

    it "must not be equal to a non-zero Array" do
      refute_equal zero, [3,2]
      refute_equal [3,2], zero
    end

    it "must be equal to a zero Size" do
      _(zero).must_be :==, Size[0,0]
      _(zero).must_be :eql?, Size[0,0]
      assert_equal zero, Size[0,0]
    end

    it "must not be equal to a non-zero Size" do
      refute_equal zero, Size[3,2]
      refute_equal zero, Size[3,2]
    end

    it "must be equal to an Vector of zeroes" do
      _(zero).must_be :eql?, Vector[0,0]
      assert_equal zero, Vector[0,0]
    end

    it "must not be equal to a non-zero Vector" do
      refute_equal zero, Vector[3,2]
    end
  end
end
