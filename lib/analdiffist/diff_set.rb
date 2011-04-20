module AnalDiffist
  class DiffSet
    def initialize before, after
      @before = before
      @after = after
    end

    def added_problems
      differences.select {|problem| problem.score > 0 }
    end

    def removed_problems
      differences.select {|problem| problem.score < 0 }
    end

    private
    def differences
      @differences ||=  begin
        before_by_context = @before.group_by {|b| [b.type, b.context]}
        after_by_context = @after.group_by {|b| [b.type, b.context]}

        keys = (before_by_context.keys + after_by_context.keys).uniq
        to_return = []
        keys.each do |key| #=> [Reek, 'Class#method']
          before_problems = before_by_context[key] || []
          after_problems = after_by_context[key] || []

          to_return = to_return.concat(compare_problem_sets(before_problems, after_problems))
        end
        to_return.reject(&:nil?)
      end
    end

    def compare_problem_sets(before_problems, after_problems)
      count_in_both = [before_problems.length,after_problems.length].min
      diffs = []
      0.upto(count_in_both - 1) do |i|
        diffs << after_problems[i].diff(before_problems[i])
      end

      added =  compare_difference_lists(before_problems, after_problems)
      removed =  compare_difference_lists(after_problems, before_problems).map{|diff| InvertedDiff.new(diff)}
      diffs + added + removed
    end

    def compare_difference_lists a, b
      to_return = []
      a.length.upto(b.length - 1) do |i|
        to_return << b[i].diff(nil)
      end
      to_return
    end
  end

  class ScoreDiffSet
  end
end
