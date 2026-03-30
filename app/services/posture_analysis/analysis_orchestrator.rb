#
# orchestre l'analyse et la réponse
#
module PostureAnalysis
  class AnalysisOrchestrator
    def initialize(args)
      @params = args[:params]
      @landmarks_normalizer = args[:landmarks_normalizer]
      @kpi_computer = args[:kpi_computer]
      @kpi_classifier = args[:kpi_classifier]
      @feedback_generator = args[:feedback_generator]
    end

    def call
      landmarks = landmarks_normalizer.new(params)
      kpis = kpi_computer.new(landmarks).call
      classify_kpi = kpi_classifier.new(kpis).call
      feedback_generator.new(classify_kpi).call
    end

    private
    attr_reader :params, :landmarks_normalizer, :kpi_computer, :kpi_classifier, :feedback_generator
  end
end
