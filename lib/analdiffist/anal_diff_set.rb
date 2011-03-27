module AnalDiffist
  class AnalDiffSet
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
      a.select {|problem| !b.any? {|problem2| [problem.type, problem.context] == [problem2.type, problem2.context] }}
    end
  end
end
