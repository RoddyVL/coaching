module PostureAnalysis
    module VideoAnalysis
        class AnalysisOrchestrator
            def initialize(args)
                @params = args[:params]
                @landmarks_normalizer = args[:landmarks_normalizer]
                @kpi_computer = args[:kpi_computer]
                @kpi_classifier = args[:kpi_classifier]
                @feedback_generator = args[:feedback_generator]
            end

            def call
                normalize_landmarks = params[:landmarks].map do |landmarks|
                    landmark = landmarks_normalizer.new(
                        landmarks: landmarks[:landmarks], 
                        stance: params[:stance],
                        timestamp: landmarks[:timestamp]
                        )
                end
            end

            private
            attr_reader :params, :landmarks_normalizer, :kpi_computer, :kpi_classifier, :feedback_generator
        end
    end
end