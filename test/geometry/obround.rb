require 'minitest/autorun'
require 'geometry/obround'

describe Geometry::Obround do
  Obround = Geometry::Obround

  describe "when constructed" do
    it "must accept two Points" do
      obround = Geometry::Obround.new [1,2], [3,4]
      assert_kind_of Geometry::Obround, obround
    end

    it "must accept a width and height" do
      obround = Geometry::Obround.new 2, 3
      assert_kind_of Geometry::Obround, obround
      assert_equal obround.height, 3
      assert_equal obround.width, 2
    end

    it "must compare equal" do
      obround = Geometry::Obround.new [1,2], [3,4]
      assert_equal obround, Obround.new([1,2], [3,4])
    end
  end
end
