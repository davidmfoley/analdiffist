module AnalDiffist
  require 'analdiffist/target_finder'
  class Diffist
  end

  require 'tmpdir'
  class Anal < Diffist
    def run(start_ref, end_ref)
      @targets = AnalDiffist::TargetFinder.new
      current_branch = get_current_branch
      puts "current branch: #{current_branch}"
      stashed = try_to_stash

      ref = get_refs_to_diff current_branch, start_ref, end_ref

      file_1 = analyze_ref(ref[0])
      file_2 = analyze_ref(ref[1])

      begin
        echo_exec "git checkout #{current_branch}" if current_branch != ref[1]
      rescue Exception
      end

      if stashed
        echo "unstashing"
        echo_exec "git stash apply"
      end

      diff file_1, file_2
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
      file = get_file_name ref_name
      begin
        echo_exec "git checkout #{ref_name}"
        do_analytics file, ref_name
      rescue Exception
      end

      file
    end

    def get_file_name ref_name

      File.join(Dir.tmpdir, "#{ref_name.gsub('/', '_')}-analytics.txt")
    end

    def do_analytics dest_filename, ref_name
      puts 'writing analytics to ' + dest_filename
      reek_result = `reek -q #{@targets}`
      flog_result = `flog -g #{@targets}`
      File.open(dest_filename, 'w') do |f|
        f.write"--- Analytics for #{ref_name} ---\n\n"

        f.write"\n\n--- FLOG ---\n\n"
        f.write clean_up_flog(flog_result)

        f.write"\n\n--- REEK ---\n\n"
        f.write reek_result
      end
    end

    def clean_up_flog(flog_result)
      flog_result.gsub(/:[0-9]+$/, '')
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

    def diff f1, f2
      echo_exec "git diff --color=always -U0 -- '#{f1}' '#{f2}'"
    end

  end
end
