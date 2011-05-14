require 'flog'
module AnalDiffist
  class FlogParser
    def initialize paths, threshold = 10.0
      @paths = paths
      @flog_threshold = threshold
    end

    def problems
      f = Flog.new
      f.flog(@paths)
      problems = []
      f.each_by_score{|class_method, score, ignore_for_now| problems << FlogProblem.new(class_method, score, @flog_threshold)}
      problems
      #problems.select {|p| p.score >= @flog_threshold}
    end
  end

  class FlogProblem
    attr_accessor :context, :score
    def initialize class_method, score, threshold = 10
      @context = class_method || '(none)'
      @score = score.round(1)
      @flog_threshold = threshold
    end

    def type
      'flog score'
    end

    def diff other
      return FlogDiff.new(@context, 0, score) if other.nil?

      return nil if other.score == score
      FlogDiff.new(@context, other.score, score)
    end

    def description
      "Flog: #{score}"
    end
  end

  class FlogDiff
    attr_accessor :context, :score
    def initialize context, previous_score, current_score
      @context = context
      @current_score = current_score
      @previous_score = previous_score
    end

    def score
      (@current_score - @previous_score).round(1)
    end

    def invert!
      score = 0 - (score || 0)
      self
    end

    def description(mode = :added)
      indicator = (mode == :added) ? "+" : "-"
      "Flog: #{@current_score.round(1)} (#{indicator}#{(@current_score - @previous_score).round(1)})"
    end
  end

  class InvertedDiff
    def initialize inner
      @inner = inner 
    end

    def context
      @inner.context
    end

    def score
      0-@inner.score
    end
    
    def type
      @inner.type
    end

    def description(mode = :added)
      @inner.description(mode)
    end
  end
end
