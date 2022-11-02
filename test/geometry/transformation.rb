require 'minitest/autorun'
require 'geometry/point'
require 'geometry/transformation'

describe Geometry::Transformation do
  Transformation = Geometry::Transformation

  describe "when constructed" do
    it "must accept nothing and become an identity transformation" do
      assert_equal Transformation.new.identity?, true
    end

    it "must accept a translate parameter" do
      assert_equal Transformation.new([4,2]).translation, Point[4,2]
    end

    it "must accept a translate Array" do
      translate = Transformation.new(:translate => [4,2])
      assert_equal translate.translation, Point[4,2]
    end

    it "must accept a translate Point" do
      translate = Transformation.new(:translate => Point[4,2])
      assert_equal translate.translation, Point[4,2]
    end

    it "must accept a translate Point equal to zero" do
      translate = Transformation.new(:translate => [0,0])
      assert_nil translate.translation
    end

    it "must accept a translate Vector" do
      translate = Transformation.new(:translate => Vector[4,2])
      assert_equal translate.translation, Point[4,2]
    end

    it "must accept an origin option" do
      translate = Transformation.new(:origin => [4,2])
      assert_equal translate.translation, Point[4,2]
    end

    it "must raise an exception when given too many translation options" do
      assert_raises(ArgumentError) { Transformation.new(:translate => [1,2], :origin => [3,4]) }
    end

    describe "when given a dimensions option" do
      it "must raise an exception if the other arguments are too big" do
        assert_raises(ArgumentError) { Transformation.new(:dimensions => 2, :origin => [1,2,3]) }
      end

      it "must raise an exception if the other arguments are too small" do
        assert_raises(ArgumentError) { Transformation.new(:dimensions => 3, :origin => [1,2]) }
      end

      it "must not complain when given only a dimensions option" do
        assert_equal Transformation.new(:dimensions => 3).dimensions, 3
      end
    end

    describe "rotation" do
      it "must accept a y axis option" do
        t = Transformation.new(:y => [1,0])
        assert_equal t.rotation.y, [1,0]
        refute_equal t.identity?, true
      end

      it "must accept a rotation angle" do
        transformation = Transformation.new(angle:90)
        refute_equal transformation.identity?, true
        refute_nil transformation.rotation
        assert_equal transformation.rotation.angle, 90
      end

      it "must accept a rotation angle specified by an X-axis" do
        transformation = Transformation.new(x:[0,1])
        rotation = transformation.rotation
        _(rotation).must_be_instance_of(RotationAngle)
        assert_equal rotation.angle, Math::PI/2
        assert_in_delta rotation.x.x, 0, 0.0001
        assert_in_delta rotation.x.y, 1, 0.0001
        assert_in_delta rotation.y.x, -1, 0.0001
        assert_in_delta rotation.y.y, 0, 0.0001
      end
    end
  end

  describe "comparison" do
    subject { Transformation.new(origin:[1,2]) }

    it "must equate equal transformations" do
      assert_equal subject, Transformation.new(origin:[1,2])
    end

    it "must not equal nil" do
      refute_equal subject.eql?(nil), true
    end

    it "must not equate a translation with a rotation" do
      refute_equal subject, Transformation.new(x:[0,1,0], y:[1,0,0])
    end

    it "must equate empty transformations" do
      assert_equal Transformation.new, Transformation.new
    end
  end

  describe "attributes" do
    describe "has_rotation?" do
      it "must properly be true" do
        assert_equal Transformation.new(angle:90).has_rotation?, true
      end

      it "must properly be false" do
        assert_equal Transformation.new.has_rotation?, false
      end
    end
  end

  describe "composition" do
    let(:translate_left) { Geometry::Transformation.new(origin:[-2,-2]) }
    let(:translate_right) { Geometry::Transformation.new(origin:[1,1]) }
    let(:transformation) { Geometry::Transformation.new }

    it "must add pure translation" do
      assert_equal translate_left + translate_right, Geometry::Transformation.new(origin:[-1,-1])
    end

    it "must add translation and no translation" do
      assert_equal transformation + translate_left, translate_left
      assert_equal translate_left + transformation, translate_left
    end

    it "array addition" do
      assert_equal (transformation + [1,2]).translation, Point[1,2]
      assert_equal ((transformation + [1,2]) + [2,3]).translation, Point[3,5]
      assert_nil (transformation + [1,2]).rotation
    end

    it "must update the translation when an array is subtracted" do
      assert_equal (transformation - [1,2]).translation, Point[-1,-2]
      assert_equal ((transformation - [1,2]) - [2,3]).translation, Point[-3,-5]
      assert_nil (transformation - [1,2,3]).rotation
    end

    it "must subtract translation and no translation" do
      assert_equal transformation - translate_left, translate_left
      assert_equal translate_left - transformation, translate_left
    end
  end

  describe "when transforming a Point" do
    describe "when no transformation is set" do
      it "must return the Point" do
        assert_equal Transformation.new.transform(Point[1,2]), Point[1,2];
      end
    end

    it "must translate" do
      assert_equal Geometry::Transformation.new(origin:[0,1]).transform([1,0]), Point[1,1]
    end

    it "must rotate" do
      rotated_point = Transformation.new(angle:Math::PI/2).transform([1,0])
      assert_in_delta rotated_point.x, 0, 0.0001
      assert_in_delta rotated_point.y, 1, 0.0001
    end

  end
end
