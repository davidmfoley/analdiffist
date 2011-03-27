module AnalDiffist
  require 'analdiffist/target_finder'
  require 'analdiffist/reek_metrics'
  require 'analdiffist/reek_parser'
  require 'analdiffist/diff_set'
  require 'analdiffist/text_based_diffist'

  class Diffist
  end

  require 'tmpdir'
  class Anal < Diffist
    def initialize
      @diffist = AnalDiffist::TextBasedDiffist.new
    end

    def run(start_ref, end_ref)
      @targets = AnalDiffist::TargetFinder.new
      current_branch = get_current_branch
      puts "current branch: #{current_branch}"
      stashed = try_to_stash

      ref = get_refs_to_diff current_branch, start_ref, end_ref

      file_1 = analyze_ref(ref[0])
      file_2 = analyze_ref(ref[1])

      begin
        echo_exec "git checkout -q #{current_branch}" if current_branch != ref[1]
      rescue Exception
      end

      if stashed
        echo "unstashing"
        echo_exec "git stash apply"
      end

      @diffist.report_results
    end

    def get_current_branch
      current_branch_raw = echo_exec "git branch --no-color"
      lines = current_branch_raw.split("\n")
      current_branch_line = lines.detect{|x| x[0] == '*'}
      current_branch = current_branch_line.split(' ')[1]
    end

    def get_refs_to_diff current_branch, start_ref, end_ref
      [ start_ref || "origin/master", end_ref || current_branch]
    end

    def analyze_ref ref_name
      begin
        echo_exec "git checkout -q #{ref_name}"
        @diffist.do_analytics ref_name
      rescue Exception
      end

      file
    end

    def echo s
      puts s
    end

    def echo_exec command
      puts command
      result = `#{command}`
      puts result
      result
    end

    def try_to_stash
      result = echo_exec "git stash"
      !(result =~ /No local changes to save/)
    end

  end
end
