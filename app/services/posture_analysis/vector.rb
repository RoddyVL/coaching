module PostureAnalysis
  class Vector
    attr_reader :x, :y, :z, :visibility

    def initialize(x:, y:, z:, visibility:)
      @x = x
      @y = y
      @z = z
      @visibility = visibility
    end

    def euclidean_distance_to(landmark)
      point1 = [x, y]
      point2 = [landmark.x, landmark.y]

      Math.sqrt(point1.zip(point2).reduce(0) { |sum, p| sum + (p[0] - p[1]) ** 2 })
    end

    def angle_degree_with(landmark)
      dx = landmark.x - x
      dy = landmark.y - y

      Math.atan2(dy, dx) * (180 / Math::PI)
    end
  end
end
