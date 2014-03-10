require_relative 'point'

module Geometry

	class Text
		
		# @return [Point]   The point located in the top left corner of {Text}'s
		# bounding box
		attr_reader :position

		# @return [String]  The {Text}'s textual content
		attr_reader :content
		
		def initialize(position, content)
			@position = Point[position]
			@content = content
		end
		
		def eql?(other)
			self.content == other.content
		end
		alias :== :eql?
	end
end