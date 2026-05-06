# analysis_orchestrator.rb
module PostureAnalysis
  module VideoAnalysis
    class AnalysisOrchestrator
      def initialize(args)
        @params               = args[:params]
        @landmarks_normalizer = args[:landmarks_normalizer]
        @kpi_computer         = args[:kpi_computer]
        @kpi_classifier       = args[:kpi_classifier]
        @kpi_summarizer       = args[:kpi_summarizer]
        @feedback_generator   = args[:feedback_generator]
      end

      def call
        normalized = normalize(params[:landmarks])
        computed   = compute_kpis(normalized)
        classified = classify_kpis(computed)
        grouped    = group_by_kpi(classified)
        summary    = kpi_summarizer.new(grouped).call

        feedback_generator.new(summary).call
      end

      private

      attr_reader :params, :landmarks_normalizer, :kpi_computer,
                  :kpi_classifier, :kpi_summarizer, :feedback_generator

      def normalize(landmarks)
        landmarks.map do |frame|
          landmarks_normalizer.new(
            landmarks: frame[:landmarks],
            stance:    params[:stance],
            timestamp: frame[:timestamp].round(2)
          )
        end
      end

      def compute_kpis(normalized_frames)
        normalized_frames.map do |frame|
          { timestamp: frame.timestamp, kpis: kpi_computer.new(frame).call }
        end
      end

      def classify_kpis(computed_frames)
        computed_frames.map do |frame|
          { timestamp: frame[:timestamp], classified_kpis: kpi_classifier.new(frame[:kpis]).call }
        end
      end

      def group_by_kpi(classified_frames)
        result = Hash.new { |h, k| h[k] = [] }
        classified_frames.each do |frame|
          frame[:classified_kpis].each do |kpi, value|
            result[kpi] << { timestamp: frame[:timestamp], value: value }
          end
        end
        result
      end
    end
  end
end