module AnalDiffist
  class StandardDiffist
    def initialize options = {}
      @targets = options[:targets] || AnalDiffist::TargetFinder.new
      @reporter = options[:reporter] || AnalDiffist::StdOutReporter.new
      @parsers = options[:parsers] || [FlogParser, ReekParser]

      @revisions = []
    end

    def do_analytics name
      #puts 'analyzing ' + name
      #puts @revisions.inspect
      @revisions << ProblemSet.new(name, @parsers, @targets)
      #puts @revisions.inspect
    end

    def report_results
      #puts @revisions.inspect
      before = @revisions[0]
      after = @revisions[1]
      diff = DiffSet.new(before.problems, after.problems)

      @reporter.report(diff)

    end

    private

    class ProblemSet
      attr_accessor :problems
      def initialize name, parsers, targets
        @problems = []
        parsers.each do |parser|
          parser_instance = parser.new(targets.targets)
          problems = parser_instance.problems
          @problems += (problems || [])
        end
      end
    end
  end

  class StdOutReporter
    def report diff
      puts "\nAdded:\n"
      puts describe(diff.added_problems)
      puts "\nRemoved:\n"
      puts describe(diff.removed_problems)
      #puts diff.inspect
    end

    def describe(problems)
      by_context = problems.group_by {|prob| prob.context}
      results = []
      by_context.keys.sort.each do |k|  
        results << "  #{k}"
        results << by_context[k].map {|p| "    #{p.description}"}.join("\n")
      end.collect
      results.join("\n")
    end
  end
end
