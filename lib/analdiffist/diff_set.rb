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

        diffs.concat(calculate_diffs_for_a_context(before, after))
      end
      diffs.reject(&:nil?)
    end

    def calculate_diffs_for_a_context before, after
      diffs = []
      while before.any? || after.any? do
        diff = get_diff(before.pop, after.pop)
        diffs << diff unless diff.nil?
      end
      diffs
    end

    def get_diff before, after
      return after.diff(before) unless after.nil?
      diff = before.diff(after)
      return nil if diff.nil?
      InvertedDiff.new(diff)
    end
  end
end
