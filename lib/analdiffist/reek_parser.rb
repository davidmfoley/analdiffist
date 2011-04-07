require 'reek'
module AnalDiffist
  class ReekParser
    attr_accessor :problems

    def initialize(paths)
      examiner = Reek::Examiner.new(paths)
      @problems = examiner.smells.map {|smell| ReekProblem.new(smell)}
    end

    def diff(previous)
      AnalDiffist::DiffSet.new(previous.problems, self.problems)
    end

    class ReekProblem
      def initialize smell
        @smell = smell
      end

      def type
        @smell.subclass.to_s
      end

      def context
        @smell.location["context"]
      end

      def score 
        1
      end
    end
  end
end
