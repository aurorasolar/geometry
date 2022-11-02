require 'minitest/autorun'
require 'geometry/rotation'

describe Geometry::Rotation do
  Point = Geometry::Point
  Rotation = Geometry::Rotation
  RotationAngle = Geometry::RotationAngle

  describe "when constructed" do
    it "must accept a rotation angle" do
      rotation = Rotation.new angle:Math::PI/2
      _(rotation).must_be_instance_of(RotationAngle)
      assert_equal rotation.angle, Math::PI/2
      assert_in_delta rotation.x.x, 0, 0.0001
      assert_in_delta rotation.x.y, 1, 0.0001
      assert_in_delta rotation.y.x, -1, 0.0001
      assert_in_delta rotation.y.y, 0, 0.0001
    end

    it "must accept an X axis" do
      rotation = Rotation.new x:[1,0]
      _(rotation).must_be_instance_of(RotationAngle)
      assert_equal rotation.angle, 0
      assert_equal rotation.x, Point[1,0]
      assert_equal rotation.y, Point[0,1]
    end
  end

  it "must accept x and y axes" do
    rotation = Geometry::Rotation.new :x => [1,2,3], :y => [4,5,6]
    assert_equal rotation.x, [1,2,3]
    assert_equal rotation.y, [4,5,6]
  end

  it "must accept 3-element x and y axes and a dimensionality of 3" do
    rotation = Geometry::Rotation.new(:dimensions => 3, :x => [1,2,3], :y => [4,5,6])
    assert_equal rotation.dimensions, 3
  end

  it "must reject 3-element x and y axes and a dimensionality of 2" do
    assert_raises(ArgumentError) { Geometry::Rotation.new(:dimensions => 2, :x => [1,2,3], :y => [4,5,6]) }
  end

  it "must promote 2-element Vectors to dimensionality of 3" do
    rotation = Geometry::Rotation.new(:dimensions => 3, :x => [1,2], :y => [4,5])
    assert_equal rotation.dimensions, 3
    assert_equal rotation.x, [1,2,0]
    assert_equal rotation.y, [4,5,0]
  end

  it "must be the identity rotation if no axes are given" do
    assert_equal Geometry::Rotation.new.identity?, true
    assert_equal Geometry::Rotation.new(:dimensions => 3).identity?, true
  end

  it "must have a matrix accessor" do
    r = Geometry::Rotation.new(:x => [1,0,0], :y => [0,1,0])
    assert_equal r.matrix, Matrix[[1,0,0],[0,1,0],[0,0,1]]
  end

  describe "when comparing" do
    it "must equate equal objects" do
      assert_equal Rotation.new(x:[1,2,3], y:[4,5,6]), Rotation.new(x:[1,2,3], y:[4,5,6])
    end
  end

  describe "comparison" do
    it "must equate equal angles" do
      assert_equal Rotation.new(angle:45), Rotation.new(angle:45)
    end

    it "must not equate unequal angles" do
      refute_equal Rotation.new(angle:10), Rotation.new(angle:45)
    end
  end

  describe "composition" do
    it "must add angles" do
      assert_equal Rotation.new(angle:45) + Rotation.new(angle:45), Rotation.new(angle:90)
    end

    it "must subtract angles" do
      assert_equal Rotation.new(angle:45) - Rotation.new(angle:45), Rotation.new(angle:0)
    end

    it "must negate angles" do
       assert_equal -Rotation.new(angle:45), Rotation.new(angle:-45)
    end
  end

  describe "when transforming a Point" do
    describe "when no rotation is set" do
      it "must return the Point" do
        assert_equal Rotation.new.transform(Point[1,0]), Point[1,0]
      end
    end

    it "must rotate" do
      rotated_point = Rotation.new(angle:Math::PI/2).transform(Point[1,0])
      assert_in_delta rotated_point.x, 0, 0.0001
      assert_in_delta rotated_point.y, 1, 0.0001
    end
  end
end
