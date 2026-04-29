module PostureAnalysis
    module VideoAnalysis
        class FrameAnalyzer
            def initialize(frame:, kpi_computer:, kpi_classifier:)
                @frame = frame
                @kpi_computer = kpi_computer
                @kpi_classifier = kpi_classifier
            end

            def call
                kpis = kpi_computer.new(frame.landmarks).call
                classification = kpi_classifier.new(kpis).call

                {
                    timestamp: frame.timestamp,
                    kpis: kpis,
                    classification: classification
                }
            end

            private

            attr_reader :frame, :kpi_computer, :kpi_classifier
        end
    end
end