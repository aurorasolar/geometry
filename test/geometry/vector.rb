require 'minitest/autorun'
require 'geometry/vector'

describe Vector do
  describe "when monkeypatching Vector" do
    let(:left) { Vector[1,2] }
    let(:right) { Vector[3,4] }

    it "must have +@" do
      assert_equal +left, Vector[1,2]
    end

    it "must have unary negation" do
      assert_equal -left, Vector[-1,-2]
    end

    it "must cross product" do
      assert_equal left.cross(right), -2
      assert_equal Vector[1,2,3].cross(Vector[3,4,5]), Vector[-2, 4, -2]
      assert_equal Vector[1,2,3] ** Vector[3,4,5], Vector[-2, 4, -2]
    end

    it "must have a constant representing the X axis" do
      assert_equal Vector::X, Vector[1,0,0]
    end

    it "must have a constant representing the Y axis" do
      assert_equal Vector::Y, Vector[0,1,0]
    end

    it "must have a constant representing the Z axis" do
      assert_equal Vector::Z, Vector[0,0,1]
    end

    it "must not create global axis constants" do
      assert_raises(NameError) { X }
      assert_raises(NameError) { Y }
      assert_raises(NameError) { Z }
    end
  end
end
