# kpi_summarizer.rb
module PostureAnalysis
  module VideoAnalysis
    class KpiSummarizer
      def initialize(grouped_kpis)
        @grouped_kpis = grouped_kpis
      end

      def call
        {
          global_scores: global_scores,
          events:        events,
          worst_kpis:    worst_kpis
        }
      end

      private

      attr_reader :grouped_kpis

      def global_scores
        grouped_kpis.transform_values do |frames|
          total   = frames.size.to_f
          optimal = frames.count { |f| f[:value] == :optimal }
          (optimal / total * 100).round(1)
        end
      end

      def events
        grouped_kpis.flat_map do |kpi, frames|
          consecutive_runs(frames)
            .reject  { |run| run[:value] == :optimal }
            .map     { |run| run.merge(kpi: kpi) }
        end.sort_by { |e| e[:start_time] }
      end

      def worst_kpis
        global_scores
          .reject  { |_, score| score == 100.0 }
          .sort_by { |_, score| score }
          .map     { |kpi, score| { kpi: kpi, optimal_pct: score } }
      end

      def consecutive_runs(frames)
        return [] if frames.empty?

        runs        = []
        run_start   = frames.first
        current_val = frames.first[:value]

        frames.each do |frame|
          if frame[:value] != current_val
            runs << { value: current_val, start_time: run_start[:timestamp], end_time: frame[:timestamp] }
            run_start   = frame
            current_val = frame[:value]
          end
        end
        runs << { value: current_val, start_time: run_start[:timestamp], end_time: frames.last[:timestamp] }
        runs
      end
    end
  end
end