module AnalDiffist
  class TargetFinder
    def initialize
    end
    def targets
      @targets = []
      @targets << "lib" if Dir.exists?("lib")
      @targets << "app" if Dir.exists?("app")
      @targets
    end

    def to_s
      targets.join(' ')
    end

  end
end
