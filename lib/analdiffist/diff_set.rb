module AnalDiffist
  class DiffSet
    def initialize before, after
      @before = before
      @after = after
    end

    def added_problems
      compare(@after, @before)
    end

    def removed_problems
      compare(@before, @after)
    end

    private
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
