require 'flog'
module AnalDiffist
  class FlogParser
    def initialize paths
      @paths = paths
    end
    def problems
      f = Flog.new
      f.flog(@paths)
      problems = []
      f.each_by_score{|class_method, score, ignore_for_now| problems << FlogProblem.new(class_method, score)}
      problems
    end
  end

  class FlogProblem
    attr_accessor :context, :score
    def initialize class_method, score
      @context = class_method
      @score = score
    end

    def type
      'flog score'
    end

  end
end
