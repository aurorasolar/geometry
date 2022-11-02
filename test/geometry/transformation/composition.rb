require 'minitest/autorun'
require 'geometry/transformation/composition'

describe Geometry::Transformation::Composition do
  Composition = Geometry::Transformation::Composition
  Transformation = Geometry::Transformation

  subject { Composition.new }

  describe "when constructed" do
    it "must accept multiple transformations" do
      composition = Composition.new(Transformation.new, Transformation.new)
      assert_equal composition.size, 2
    end

    it "must reject anything that isn't a Transformation" do
      assert_raises(TypeError) { Composition.new :foo }
    end
  end

  describe "attributes" do
    describe "has_rotation?" do
      it "must properly be true" do
        assert Composition.new(Transformation.new(angle:90)).has_rotation?
      end

      it "must properly be false" do
        refute subject.has_rotation?
      end
    end
  end

  describe "when composing" do
    it "must append a Transformation" do
      assert_equal (Composition.new(Transformation.new) + Transformation.new).size, 2
    end

    it "must merge with a Composition" do
      assert_equal (Composition.new(Transformation.new) + Composition.new(Transformation.new)).size, 2
    end
  end

  describe "when transforming a Point" do
    it "must handle composed translations" do
      composition = Composition.new(Transformation.new(origin:[1,2])) + Composition.new(Transformation.new [3,4])
      assert_equal composition.transform(Point[5,6]), Point[9, 12]
    end
  end
end
