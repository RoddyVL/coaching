module PostureAnalysis
  class KPIComputer
    def initialize(landmarks)
      @landmarks = landmarks
    end

    def call
      {
        foot_shoulders_width_ratio:,
        foot_depth:
      }
    end

    def foot_shoulders_width_ratio
      shoulder_distance = euclidean_distance(landmarks.left_shoulder, landmarks.right_shoulder)
      ankle_distance = euclidean_distance(landmarks.left_ankle, landmarks.right_ankle)

      (ankle_distance / shoulder_distance)
    end

    def foot_depth

    end

    private
    attr_reader :landmarks

    # The points have to be in the format [x, y]
    def euclidean_distance(landmark1, landmark2)
      point1 = [landmark1[:x], landmark1[:y]]
      point2 = [landmark2[:x], landmark2[:y]]

      Math.sqrt(point1.zip(point2).reduce(0) { |sum, p| sum + (p[0] - p[1]) ** 2 })
    end
  end
end
