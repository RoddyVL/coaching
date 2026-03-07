module PostureAnalysis
  class FeedbackGenerator
    def initialize(classify_kpis)
      @classify_kpis = classify_kpis
    end

    def call
    end
    private
    attr_reader :classify_kpis
  end
end
