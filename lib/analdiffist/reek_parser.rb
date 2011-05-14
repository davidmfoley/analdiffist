require 'reek'
module AnalDiffist
  class ReekParser
    attr_accessor :problems

    def initialize(paths)
      @examiner = Reek::Examiner.new(paths)
      @problems = get_problems
    end

    def get_problems
      unfiltered = @examiner.smells.map {|smell| ReekProblem.new(smell)}
      filter_reek_problems(unfiltered)
    end

    def filter_reek_problems(reek_problems)
      reek_problems
    end

    def diff(previous)
      AnalDiffist::DiffSet.new(previous.problems, self.problems)
    end
  end

  class ReekProblem
    def initialize smell
      @smell = smell
    end

    def type
      @smell.subclass.to_s || ''
    end

    def context
      @smell.location["context"]
    end

    def diff other
      self if other.nil?
    end

    def score
      2
    end

    def description(mode = :added)
      "Reek: #{type}"
    end
  end
end
