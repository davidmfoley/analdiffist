module AnalDiffist
  require 'analdiffist/target_finder'
  require 'analdiffist/reek_metrics'
  require 'analdiffist/reek_parser'
  require 'analdiffist/flog_parser'
  require 'analdiffist/diff_set'
  require 'analdiffist/text_based_diffist'
  require 'analdiffist/standard_diffist'

  class Diffist
  end

  require 'tmpdir'
  class Anal < Diffist
    def initialize
      @diffist = AnalDiffist::StandardDiffist.new
    end

    def run(start_ref, end_ref)
      current_branch = get_current_branch
      stashed = try_to_stash

      ref = get_refs_to_diff current_branch, start_ref, end_ref
      puts "\nAnaldiffizing: #{ref.join(" -> ")}"
      analyze_ref(ref[0])
      analyze_ref(ref[1])

      begin
        if current_branch != ref[1]
          puts "  checking out original revision: #{current_branch}"
          checkout_revision current_branch
        end
      rescue Exception
      end

      if stashed
        puts "unstashing"
        `git stash apply`
      end

      @diffist.report_results
    end

    def get_current_branch
      current_branch_raw = `git branch --no-color`
      lines = current_branch_raw.split("\n")
      current_branch_line = lines.detect{|x| x[0] == '*'}
      current_branch = current_branch_line.split(' ')[1]
    end

    def get_refs_to_diff current_branch, start_ref, end_ref
      [ start_ref || "origin/master", end_ref || current_branch]
    end

    def analyze_ref ref_name
      begin
        checkout_revision ref_name
        puts "  analyzing revision: #{ref_name}"
        @diffist.do_analytics ref_name
      rescue Exception
        puts "Error in analyze_ref: " + $!.to_s
      end

    end

    def checkout_revision ref_name
        puts "  checking out revision: #{ref_name}"
        `git checkout -q #{ref_name}`
    end

    def try_to_stash
      result =  `git stash`
      stashed = !(result =~ /No local changes to save/)
      puts "stashed local uncommitted changes" if stashed
      stashed
    end

  end
end
