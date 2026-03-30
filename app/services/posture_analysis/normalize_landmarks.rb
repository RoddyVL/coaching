module PostureAnalysis
  class NormalizeLandmarks
    ORTHODOX = 'orthodox'.freeze
    LANDMARKS = %i[
      nose
      left_eye_inner left_eye left_eye_outer
      right_eye_inner right_eye right_eye_outer
      left_ear right_ear
      mouth_left mouth_right
      left_shoulder right_shoulder
      left_elbow right_elbow
      left_wrist right_wrist
      left_pinky right_pinky
      left_index right_index
      left_thumb right_thumb
      left_hip right_hip
      left_knee right_knee
      left_ankle right_ankle
      left_heel right_heel
      left_foot_index right_foot_index
    ]

    NORMALIZE_PARTS = %i[ankle foot_index heel].freeze

    def initialize(params)
      @landmarks = params[:landmarks]
      @stance = params[:stance]
    end

    LANDMARKS.each_with_index do |name, index|
      define_method(name) do
        Landmark.new(**landmarks[index])
      end
    end

    Landmark = Struct.new(:x, :y, :z, :visibility)

    NORMALIZE_PARTS.each do |part|
      define_method("lead_#{part}") do
        body_part(lead_side, part)
      end

      define_method("rear_#{part}") do
        body_part(rear_side, part)
      end
    end

    private
    attr_reader :landmarks, :stance

    def lead_side
      stance == ORTHODOX ? :left : :right
    end

    def rear_side
      stance == ORTHODOX ? :right : :left
    end

    def body_part(side, part)
      send("#{side}_#{part}")
    end
  end
end
