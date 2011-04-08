module AnalDiffist
  class StdOutReporter
    def report diff, from_rev, to_rev
      puts "\n\nAnaldifference between revisions: \n #{from_rev}\n #{to_rev}"
      describe_problems(diff.added_problems, 'Added', :added)
      describe_problems(diff.removed_problems, 'Removed', :removed)

      puts "\n\n"
    end

    def describe_problems problems, title, mode
      sum = 0.0
      problems.each {|p| sum += p.score}
      puts "\n#{title} (#{problems.length} : #{sum})\n"
      puts describe(problems, mode).join("\n")
    end

    def describe(problems, mode)
      results = []
      by_type = problems.group_by do |prob|
        prob.context.split(/(\#|\.)/).first
      end

      by_type.keys.sort.each do |type_name|
        results << "  #{type_name}"
        type_problems = by_type[type_name]
        by_context = type_problems.group_by do |prob|
          name = prob.context[type_name.length..-1]
        end

        by_context.keys.sort.each do |k|
          results << "    #{k == '' ? '(none)' : k}"
          results += by_context[k].map {|p| "      #{p.description(mode)}"}
        end
      end

      results
    end
  end
end
