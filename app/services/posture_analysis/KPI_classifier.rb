module PostureAnalysis
  class KPIClassifier
    UNDER_THRESHOLD = :under_threshold
    OPTIMAL =  :optimal
    ABOVE_THRESHOLD = :above_threshold

    BENCHMARKS = {
      foot_shoulders_width_ratio: { min: 1.0, max: 1.6 },
      foot_depth: { min: 0, max: 0 },
      orthodox_left_foot_angle_degree: { min: 20, max: 45 },
      orthodox_right_foot_angle_degree: { min: 60, max: 80 },
      southpaw_left_foot_angle_degree: { min: 20, max: 45 },
      southpaw_right_foot_angle_degree: { min: 60, max: 80 },
      left_hand_height_ratio: { min: -0.07, max: 0.8 },
      right_hand_height_ratio: { min:-0.07, max: 0.8 },
      left_lateral_elbow_spread: { min: 5.0, max: 23.0 },
      right_lateral_elbow_spread: { min: 5.0, max: 23.0 },
      chin_tuck: { min: 0.001, max: 0.05 }
    }.freeze

    def initialize(kpis)
      @kpis = kpis
      @classify_kpis = {}
    end

    def call
      kpis.each do |kpi, value|
        if value < BENCHMARKS.dig(kpi, :min)
          classify_kpis[kpi] = UNDER_THRESHOLD
        elsif value > BENCHMARKS.dig(kpi, :max)
          classify_kpis[kpi] = ABOVE_THRESHOLD
        else
          classify_kpis[kpi] = OPTIMAL
        end
      end

      classify_kpis
    end

    private
    attr_reader :kpis, :classify_kpis
  end
end
