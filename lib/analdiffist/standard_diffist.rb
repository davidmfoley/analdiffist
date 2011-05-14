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

      @reporter.report(diff, before.name, after.name)
    end

    def puts_problems problems
      puts problems.map {|p| "#{p.context} - #{p.description}"}.join("\n")
    end

    private

    class ProblemSet
      attr_accessor :problems, :name
      def initialize name, parsers, targets
        @name = name
        @problems = []
        parsers.each do |parser|
          parser_instance = parser.new(targets.targets)
          problems = parser_instance.problems
          @problems += (problems || [])
        end
      end
    end
  end

end
