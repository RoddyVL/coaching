module PostureAnalysis
  class KPIComputer
    ORTHODOX = 'orthodox'.freeze
    SOUTHPAW = 'southpaw'.freeze

    def initialize(landmarks)
      @landmarks = landmarks
    end

    def call
      {
        foot_shoulders_width_ratio:,
        foot_depth:,
        lead_foot_angle_degree:,
        rear_foot_angle_degree:,
        left_hand_height_ratio:,
        right_hand_height_ratio:,
        left_lateral_elbow_spread:,
        right_lateral_elbow_spread:,
        chin_tuck:
      }.compact
    end

    private

    attr_reader :landmarks

    def foot_shoulders_width_ratio
      shoulder_distance = euclidean_distance(landmarks.left_shoulder, landmarks.right_shoulder)
      ankle_distance = euclidean_distance(landmarks.left_ankle, landmarks.right_ankle)

      (ankle_distance / shoulder_distance)
    end

    def foot_depth
      landmarks.lead_heel.y - landmarks.rear_foot_index.y
    end

    def lead_foot_angle_degree
      heel = landmarks.lead_heel
      index = landmarks.lead_foot_index

      foot_angle_degree(heel:, index:)
    end

    def rear_foot_angle_degree
      heel = landmarks.rear_heel
      index = landmarks.rear_foot_index

      foot_angle_degree(heel:, index:)
    end

    def left_hand_height_ratio
      hand_height_ratio(landmarks.left_wrist.y)
    end

    def right_hand_height_ratio
      hand_height_ratio(landmarks.right_wrist.y)
    end

    def left_lateral_elbow_spread
      shoulder = landmarks.left_shoulder
      hip = landmarks.left_hip
      elbow = landmarks.left_elbow

      calculate_elbow_body_angle(shoulder:, hip:, elbow:)
    end

    def right_lateral_elbow_spread
      shoulder = landmarks.right_shoulder
      hip = landmarks.right_hip
      elbow = landmarks.right_elbow

      calculate_elbow_body_angle(shoulder:, hip:, elbow:)
    end

    def chin_tuck
      (mean_shoulder_height - landmarks.nose.y)
    end

    #
    # method below offer a convenient way to perform differents kind of computation
    #

    def hand_height_ratio(wrist_y)
      (mean_shoulder_height - wrist_y) / shoulder_nose_vertical_distance
    end

    def euclidean_distance(landmark1, landmark2)
      point1 = [landmark1.x, landmark1.y]
      point2 = [landmark2.x, landmark2.y]

      Math.sqrt(point1.zip(point2).reduce(0) { |sum, p| sum + (p[0] - p[1]) ** 2 })
    end

    def foot_angle_degree(heel:, index:)
      dx = index.x - heel.x
      dy = index.y - heel.y

      angle_rad = Math.atan2(dx, dy)
      angle_rad * (180 / Math::PI)
    end

    def mean_shoulder_height
      @mean_shoulder_height ||= (landmarks.left_shoulder.y + landmarks.right_shoulder.y) / 2
    end

    def shoulder_nose_vertical_distance
      @shoulder_nose_vertical_distance ||= mean_shoulder_height - landmarks.nose.y
    end

    def calculate_elbow_body_angle(shoulder:, hip:, elbow:)
      # 1. Création des vecteurs (Vecteur Épaule -> Hanche et Épaule -> Coude)
      ux = hip.x - shoulder.x
      uy = hip.y - shoulder.y

      vx = elbow.x - shoulder.x
      vy = elbow.y - shoulder.y

      # 2. Calcul du produit scalaire et des magnitudes
      dot_product = (ux * vx) + (uy * vy)
      mag_u = Math.sqrt(ux**2 + uy**2)
      mag_v = Math.sqrt(vx**2 + vy**2)

      # 3. Calcul de l'angle en radians puis conversion en degrés
      # Le .clamp évite les erreurs de précision flottante
      cos_theta = (dot_product / (mag_u * mag_v)).clamp(-1.0, 1.0)
      angle_rad = Math.acos(cos_theta)

      (angle_rad * 180 / Math::PI).round(2)
    end
  end
end
