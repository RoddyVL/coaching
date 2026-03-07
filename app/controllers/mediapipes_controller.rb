class MediapipesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def create
    orchestrator = PostureAnalysis::AnalysisOrchestrator.new(
      landmarks_normalizer: PostureAnalysis::NormalizeLandmarks.new(safe_params),
      kpi_computer: PostureAnalysis::KPIComputer.new,
      kpi_classifyer: PostureAnalysis::KPIClassifyer.new,
      feedback_generator: PostureAnalysis::FeedbackGenerator.new
    )

    result = orchestrator.call
  end

  private

  def safe_params
    @safe_params ||= params.except(:controller, :action).to_unsafe_h.deep_symbolize_keys
  end
end
