require 'minitest/autorun'
require 'geometry/point'
require 'geometry/transformation'

describe Geometry::Transformation do
  Transformation = Geometry::Transformation

  describe "when constructed" do
    it "must accept nothing and become an identity transformation" do
      _(Transformation.new.identity?).must_equal true
    end

    it "must accept a translate parameter" do
      _(Transformation.new([4,2]).translation).must_equal Point[4,2]
    end

    it "must accept a translate Array" do
      translate = Transformation.new(:translate => [4,2])
      _(translate.translation).must_equal Point[4,2]
    end

    it "must accept a translate Point" do
      translate = Transformation.new(:translate => Point[4,2])
      _(translate.translation).must_equal Point[4,2]
    end

    it "must accept a translate Point equal to zero" do
      translate = Transformation.new(:translate => [0,0])
      _(translate.translation).must_equal nil
    end

    it "must accept a translate Vector" do
      translate = Transformation.new(:translate => Vector[4,2])
      _(translate.translation).must_equal Point[4,2]
    end

    it "must accept an origin option" do
      translate = Transformation.new(:origin => [4,2])
      _(translate.translation).must_equal Point[4,2]
    end

    it "must raise an exception when given too many translation options" do
      lambda { Transformation.new :translate => [1,2], :origin => [3,4] }.must_raise ArgumentError
    end

    describe "when given a dimensions option" do
      it "must raise an exception if the other arguments are too big" do
        lambda { Transformation.new :dimensions => 2, :origin => [1,2,3] }.must_raise ArgumentError
      end

      it "must raise an exception if the other arguments are too small" do
        lambda { Transformation.new :dimensions => 3, :origin => [1,2] }.must_raise ArgumentError
      end

      it "must not complain when given only a dimensions option" do
        _(Transformation.new(:dimensions => 3).dimensions).must_equal 3
      end
    end

    describe "rotation" do
      it "must accept a y axis option" do
        t = Transformation.new :y => [1,0]
        _(t.rotation.y).must_equal [1,0]
        _(t.identity?).wont_equal true
      end

      it "must accept a rotation angle" do
        transformation = Transformation.new angle:90
        _(transformation.identity?).wont_equal true
        _(transformation.rotation).wont_be_nil
        _(transformation.rotation.angle).must_equal 90
      end

      it "must accept a rotation angle specified by an X-axis" do
        transformation = Transformation.new x:[0,1]
        rotation = transformation.rotation
        rotation.must_be_instance_of(RotationAngle)
        _(rotation.angle).must_equal Math::PI/2
        _(rotation.x.x).must_be_close_to 0
        _(rotation.x.y).must_be_close_to 1
        _(rotation.y.x).must_be_close_to -1
        _(rotation.y.y).must_be_close_to 0
      end
    end
  end

  describe "comparison" do
    subject { Transformation.new(origin:[1,2]) }

    it "must equate equal transformations" do
      _(subject).must_equal Transformation.new(origin:[1,2])
    end

    it "must not equal nil" do
      _(subject.eql?(nil)).wont_equal true
    end

    it "must not equate a translation with a rotation" do
      _(subject).wont_equal Transformation.new(x:[0,1,0], y:[1,0,0])
    end

    it "must equate empty transformations" do
      _(Transformation.new).must_equal Transformation.new
    end
  end

  describe "attributes" do
    describe "has_rotation?" do
      it "must properly be true" do
        _(Transformation.new(angle:90).has_rotation?).must_equal true
      end

      it "must properly be false" do
        _(Transformation.new.has_rotation?).must_equal false
      end
    end
  end

  describe "composition" do
    let(:translate_left) { Geometry::Transformation.new origin:[-2,-2] }
    let(:translate_right) { Geometry::Transformation.new origin:[1,1] }
    let(:transformation) { Geometry::Transformation.new }

    it "must add pure translation" do
      _(translate_left + translate_right).must_equal Geometry::Transformation.new origin:[-1,-1]
    end

    it "must add translation and no translation" do
      _(transformation + translate_left).must_equal translate_left
      _(translate_left + transformation).must_equal translate_left
    end

    it "array addition" do
      _((transformation + [1,2]).translation).must_equal Point[1,2]
      _(((transformation + [1,2]) + [2,3]).translation).must_equal Point[3,5]
      _((transformation + [1,2]).rotation).must_be_nil
    end

    it "must update the translation when an array is subtracted" do
      _((transformation - [1,2]).translation).must_equal Point[-1,-2]
      _(((transformation - [1,2]) - [2,3]).translation).must_equal Point[-3,-5]
      _((transformation - [1,2,3]).rotation).must_be_nil
    end

    it "must subtract translation and no translation" do
      _(transformation - translate_left).must_equal translate_left
      _(translate_left - transformation).must_equal translate_left
    end
  end

  describe "when transforming a Point" do
    describe "when no transformation is set" do
      it "must return the Point" do
        _(Transformation.new.transform(Point[1,2])).must_equal Point[1,2];
      end
    end

    it "must translate" do
      _(Geometry::Transformation.new(origin:[0,1]).transform([1,0])).must_equal Point[1,1]
    end

    it "must rotate" do
      rotated_point = Transformation.new(angle:Math::PI/2).transform([1,0])
      _(rotated_point.x).must_be_close_to 0
      _(rotated_point.y).must_be_close_to 1
    end

  end
end
