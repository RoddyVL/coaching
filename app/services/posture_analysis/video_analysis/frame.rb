module PostureAnalysis
    module VideoAnalysis
        class Frame
            attr_reader :timestamp, :landmarks

            def initialize(timestamp:, landmarks:, stance:)
                @timestamp = timestamp
                @landmarks = NormalizeLandmarks.new(
                    landmarks: landmarks,
                    stance: stance,
                    timestamp: timestamp
                )
            end
        end
    end
end