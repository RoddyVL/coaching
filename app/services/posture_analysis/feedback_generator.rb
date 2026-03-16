module PostureAnalysis
  class FeedbackGenerator
    ADVICES = {
      foot_shoulders_width_ratio: { above_threshold: 'narrow your foot width', under_threshold: 'widen your foot width' },
      foot_depth: { under_threshold: 'spread your foot depth', above_threshold: 'narrow your foot depth' },
      left_foot_angle_degree: { under_threshold: 'turn your left foot inside', above_threshold: 'turn your left foot outside' },
      right_foot_angle_degree: { under_threshold: 'turn your left foot inside', above_threshold: 'turn your left foot outside' },
      left_hand_height_ratio: { above_threshold: 'lower your left hand to your chin level, you also need to protect your body', under_threshold: 'raise your left hand to your chine' },
      right_hand_height_ratio: { above_threshold: 'lower your right hand to your chin level, you also need to protect your body', under_threshold: 'raise your right hand to your chine' },
      left_lateral_elbow_spread: { above_threshold: 'tuck your left elbow to protect your body', under_threshold: 'spread your left elbow, you are to compact' },
      right_lateral_elbow_spread: { above_threshold: 'tuck your right elbow to protect your body', under_threshold: 'spread your right elbow, you are to compact' },
      chin_tuck: { above_threshold: 'tuck your shine', under_threshold: 'your shine is too compact' }
    }.freeze

    def initialize(kpis)
      @kpis = kpis
      @feedback = []
    end

    def call
      kpis.each do |kpi, category|
        feedback << ADVICES.dig(kpi, category)
      end

      feedback.compact
    end

    private
    attr_reader :kpis, :feedback
  end
end
