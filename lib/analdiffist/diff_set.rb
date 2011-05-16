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
        @by_context = {}
        calculate_differences
      end
    end

    def calculate_differences
      diffs = []
      before_by_context = @before.group_by {|b| [b.type, b.context]}
      after_by_context = @after.group_by {|b| [b.type, b.context]}
      all_contexts = (before_by_context.keys + after_by_context.keys).uniq
      
      all_contexts.each do |context|
        before = before_by_context[context] || []
        after = after_by_context[context] || []
       

        0.upto([before.count, after.count].min - 1) do |i|
          diff = after[i].diff(before[i]) 
          diffs << diff 
        end

        before_only = before[after.length..-1] || []
        after_only = after[before.length..-1] || []
        diffs.concat before_only.map {|x| diff = x.diff(nil); diff.nil? ? nil : InvertedDiff.new(diff)}
        diffs.concat after_only.map {|x| x.diff(nil)}
      end
      diffs.reject(&:nil?)
    end

  end
end
