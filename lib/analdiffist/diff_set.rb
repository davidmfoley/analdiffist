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

          before_len = before_problems.length
          after_len = after_problems.length

          0.upto([before_len, after_len].min - 1) do |i|
            to_return << after_problems[i].diff(before_problems[i])
          end

          to_return = to_return.concat( compare_difference_lists(before_problems, after_problems))
          removed =  compare_difference_lists(after_problems, before_problems)
          to_return = to_return.concat(removed.map{|diff| InvertedDiff.new(diff)})

        end
        to_return.reject(&:nil?)
      end
    end

    def compare_difference_lists a, b
      to_return = []
      a.length.upto(b.length - 1) do |i|
        to_return << b[i].diff(nil)
      end
      to_return
    end

    def compare(a,b)
      #TODO: move this comparison into the class?
      a.map do |problem| 

        matching_problem = b.detect {|problem2| [problem.type, problem.context] == [problem2.type, problem2.context] }

          problem.diff(matching_problem)

      end.reject {|x| x.nil?}
    end
  end

  class ScoreDiffSet
  end
end
