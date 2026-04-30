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
                        timestamp: landmarks[:timestamp].round(2)
                        )
                end
             
                kpis = normalize_landmarks.map do |landmarks|
                    timestamp = landmarks.timestamp.to_s
                    kpi = kpi_computer.new(landmarks).call
                    { timestamp => kpi }
                end

                classify_kpis = kpis.map do |frame|
                    timestamp = frame.keys.first
                    classify_kpi = frame.values.first
                    { :timestamp => timestamp, :classify_kpis => kpi_classifier.new(classify_kpi).call }
                end

                group_by_kpi(classify_kpis)
            end

            private
            attr_reader :params, :landmarks_normalizer, :kpi_computer, :kpi_classifier, :feedback_generator

            def group_by_kpi(frames)
                result = Hash.new { |h, k| h[k] = [] }

                frames.each do |frame|
                    timestamp = frame[:timestamp].to_f

                    frame[:classify_kpis].each do |kpi, value|
                    result[kpi] << {
                        timestamp: timestamp,
                        value: value
                    }
                    end
                end

                result
            end
        end
    end
end