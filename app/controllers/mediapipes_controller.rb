class MediapipesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
  end

  def create
    orchestrator = PostureAnalysis::AnalysisOrchestrator.new(
      landmarks_normalizer: PostureAnalysis::NormalizeLandmarks,
      kpi_computer: PostureAnalysis::KPIComputer,
      kpi_classifier: PostureAnalysis::KPIClassifier,
      feedback_generator: PostureAnalysis::FeedbackGenerator,
      params: safe_params
    )

    result = orchestrator.call
    binding.irb
  end

  private

  def safe_params
    @safe_params ||= params.except(:controller, :action).to_unsafe_h.deep_symbolize_keys
  end
end
