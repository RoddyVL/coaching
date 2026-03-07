#
# orchestre l'analyse et la réponse
#
module PostureAnalysis
  class AnalysisOrchestrator
    def initialize(args)
      @landmarks = args[:landmarks_normalizer]
      @kpi_computer = args[:kpi_computer]
      @kpi_classifyer = args[:kpi_classifyer]
      @feedback_generator = args[:feedback_generator]
    end

    def call
      kpis = kpi_computer.call(landmarks)
    end
    # 1. normalize data
    # 2. compute KPI
    # 3. ClassifyKPI
    # 4. Generate feedback
    private
    attr_reader :landmarks, :kpi_computer, :kpi_classifyer, :feedback_generator

  end
end
