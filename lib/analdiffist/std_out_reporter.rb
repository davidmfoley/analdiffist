module AnalDiffist
  class StdOutReporter
    def report diff, from_rev, to_rev
      puts "\n\nAnaldifference between revisions: \n #{from_rev}\n #{to_rev}"
      puts "\nAdded:\n"
      puts describe(diff.added_problems, :added).join("\n")
      puts "\nRemoved:\n"
      puts describe(diff.removed_problems, :removed).join("\n")
      puts "\n\n"
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
