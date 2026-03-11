module PostureAnalysis
  class KPIComputer
    def initialize(landmarks)
      @landmarks = landmarks
    end

    def call
      {
        foot_shoulders_width_ratio:,
        foot_depth:,
        left_foot_angle_degree:,
        right_foot_angle_degree:,
        left_hand_height_ratio:,
        right_hand_height_ratio:,
        left_lateral_elbow_spread:,
        right_lateral_elbow_spread:,
        chin_tuck:
      }
    end

    private

    attr_reader :landmarks

    def foot_shoulders_width_ratio
      shoulder_distance = euclidean_distance(landmarks.left_shoulder, landmarks.right_shoulder)
      ankle_distance = euclidean_distance(landmarks.left_ankle, landmarks.right_ankle)

      (ankle_distance / shoulder_distance)
    end

    def foot_depth
      # to do
    end

    def left_foot_angle_degree
      heel = landmarks.left_heel
      index = landmarks.left_index

      foot_angle_degree(heel:, index:)
    end

    def right_foot_angle_degree
      heel = landmarks.right_heel
      index = landmarks.right_index

      foot_angle_degree(heel:, index:)
    end

    def left_hand_height_ratio
      hand_height_ratio(landmarks.left_wrist)
    end

    def right_hand_height_ratio
      hand_height_ratio(landmarks.right_wrist)
    end


    def left_lateral_elbow_spread
      lateral_elbow_spread(landmarks.left_elbow, landmarks.left_shoulder)
    end

    def right_lateral_elbow_spread
      lateral_elbow_spread(landmarks.right_elbow, landmarks.right_shoulder)
    end

    def chin_tuck
      (mean_shoulder_height - landmarks.nose.y)
    end

    #
    # method below offer a convenient way to perform differents kind of computation
    #

    #
    # expects @elbow and @shoulder of the same side
    #
    def lateral_elbow_spread(elbow, shoulder)
      width = (landmarks.left_shoulder.x - landmarks.right_shoulder.x).abs
      (elbow.x - shoulder.x) / width
    end

    def hand_height_ratio(wrist)
      wrist_height = wrist.y

      (mean_shoulder_height - wrist_height) / shoulder_nose_vertical_distance
    end

    def euclidean_distance(landmark1, landmark2)
      point1 = [landmark1.x, landmark1.y]
      point2 = [landmark2.x, landmark2.y]

      Math.sqrt(point1.zip(point2).reduce(0) { |sum, p| sum + (p[0] - p[1]) ** 2 })
    end

    def foot_angle_degree(heel:, index:)
      dx = index.x - heel.x
      dy = index.y - heel.y

      angle_rad = Math.atan2(dy, dx)
      angle_rad * (180 / Math::PI)
    end

    def mean_shoulder_height
      @mean_shoulder_height ||= (landmarks.left_shoulder.y + landmarks.right_shoulder.y) / 2
    end

    def shoulder_nose_vertical_distance
      @shoulder_nose_vertical_distance ||= mean_shoulder_height - landmarks.nose.y
    end
  end
end
