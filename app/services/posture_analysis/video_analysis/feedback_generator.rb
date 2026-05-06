# feedback_generator.rb
module PostureAnalysis
  module VideoAnalysis
    class FeedbackGenerator
      ADVICES = {
        foot_shoulders_width_ratio: { above_threshold: 'narrow your foot width',   under_threshold: 'widen your foot width' },
        foot_depth:                 { under_threshold: 'spread your foot depth',    above_threshold: 'narrow your foot depth' },
        left_foot_angle_degree:     { under_threshold: 'turn your left foot inside',  above_threshold: 'turn your left foot outside' },
        right_foot_angle_degree:    { under_threshold: 'turn your right foot inside', above_threshold: 'turn your right foot outside' },
        left_hand_height_ratio:     { above_threshold: 'lower your left hand to chin level', under_threshold: 'raise your left hand to chin level' },
        right_hand_height_ratio:    { above_threshold: 'lower your right hand to chin level', under_threshold: 'raise your right hand to chin level' },
        left_lateral_elbow_spread:  { above_threshold: 'tuck your left elbow to protect your body',  under_threshold: 'spread your left elbow, you are too compact' },
        right_lateral_elbow_spread: { above_threshold: 'tuck your right elbow to protect your body', under_threshold: 'spread your right elbow, you are too compact' },
        chin_tuck:                  { above_threshold: 'tuck your chin',            under_threshold: 'your chin is too tucked' }
      }.freeze

      def initialize(summary)
        @summary = summary
      end

      def call
        {
          global_scores:   @summary[:global_scores],
          events:          annotated_events,
          recommendations: recommendations
        }
      end

      private

      def annotated_events
        @summary[:events].map do |event|
          advice = ADVICES.dig(event[:kpi], event[:value])
          event.merge(advice: advice)
        end
      end

      def recommendations
        @summary[:worst_kpis].first(3).map do |entry|
          kpi           = entry[:kpi]
          dominant_val  = dominant_value_for(kpi)
          advice        = ADVICES.dig(kpi, dominant_val)

          {
            kpi:         kpi,
            optimal_pct: entry[:optimal_pct],
            priority:    priority_from_score(entry[:optimal_pct]),
            advice:      advice,
            see_at:      timestamps_for(kpi)
          }
        end
      end

      def dominant_value_for(kpi)
        events_for_kpi = @summary[:events].select { |e| e[:kpi] == kpi }
        events_for_kpi
          .group_by { |e| e[:value] }
          .max_by   { |_, group| group.sum { |e| e[:end_time] - e[:start_time] } }
          &.first
      end

      def priority_from_score(score)
        case score
        when 0..33  then :high
        when 34..66 then :medium
        else             :low
        end
      end

      def timestamps_for(kpi)
        @summary[:events]
          .select { |e| e[:kpi] == kpi }
          .map    { |e| e[:start_time] }
      end
    end
  end
end