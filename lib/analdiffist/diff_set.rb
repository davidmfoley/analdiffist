module AnalDiffist
  class DiffSet
    def initialize before, after
      @before = before
      @after = after
    end

    def added_problems
      differences.select {|difference| difference.score > 0 }
    end

    def removed_problems
      differences.select {|difference| difference.score < 0 }
    end

    private
    def differences
      @differences ||=  begin
        before_by_context = @before.group_by {|b| [b.type, b.context]}
        after_by_context = @after.group_by {|b| [b.type, b.context]}

        @by_context = {}

        add_to_context(before_by_context, :before)
        add_to_context(after_by_context, :after)

        calculate_differences
      end

    end

    def calculate_differences
      diffs = []
      @by_context.each do |context, problems| 
        before = problems[:before] || []
        after = problems[:after] || []
        
        0.upto([before.count, after.count].min - 1) do |i|
          diff = after[i].diff(before[i]) 
          
          diffs << diff 
        end

        before_only = before[after.length..-1] || []
        after_only = after[before.length..-1] || []
        diffs.concat before_only.map {|x| InvertedDiff.new(x.diff(nil))}
        diffs.concat after_only.map {|x| x.diff(nil)}
      end
      diffs.reject(&:nil?)
    end

    def add_to_context hash, destination_key
      hash.each do |key, value| 
        @by_context[key] ||= {}
        @by_context[key][destination_key] = value
      end
    end
  end
end
