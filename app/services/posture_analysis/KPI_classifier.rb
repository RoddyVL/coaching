module PostureAnalysis
  class KPIClassifier
    UNDER_THRESHOLD = :under_threshold
    OPTIMAL =  :optimal
    ABOVE_THRESHOLD = :above_threshold

    BENCHMARKS = {
      foot_shoulders_width_ratio: { min: 1.0, max: 1.5 },
      # foot_depth: { min: 0, max: 0 },
      left_foot_angle_degree: { min: 0, max: 0 },
      right_foot_angle_degree: { min: 0, max: 0 },
      left_hand_height_ratio: { min: 0.8, max: 1.3 },
      right_hand_height_ratio: { min: 0.8, max: 1.3 },
      left_lateral_elbow_spread: { min: -0.2, max: 0.35 },
      right_lateral_elbow_spread: { min: -0.2, max: 0.35 },
      chin_tuck: { min: 0.05, max: 0.05 }
    }.freeze

    def initialize(kpis)
      @kpis = kpis
      @classify_kpis = {}
    end

    def call
      BENCHMARKS.each do |kpi, threshold|
        if kpis[kpi] < threshold[:min]
          classify_kpis.merge!(kpi => UNDER_THRESHOLD)
        elsif kpis[kpi] > threshold[:max]
           classify_kpis.merge!(kpi => ABOVE_THRESHOLD)
        else
          classify_kpis.merge!(kpi => OPTIMAL)
        end
      end

      classify_kpis
    end

    private
    attr_reader :kpis, :classify_kpis
  end
end
