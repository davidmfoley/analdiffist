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
      a.select do |problem| 
        !b.any? do |problem2| 
          [problem.type, problem.context] == [problem2.type, problem2.context] && problem.score <= problem2.score 
        end
      end
    end
  end

  class ScoreDiffSet
  end
end
