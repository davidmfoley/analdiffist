require 'spec_helper'

describe AnalDiffist::FlogParser do
  context 'analyzing a class' do
    before do
      file_parser = get_parser_for('smelly_file.rb')
      @problems = file_parser.problems
    end
    def get_parser_for(fixture_file)
      file_name = File.join(File.dirname(__FILE__), '../../fixtures/', fixture_file)
      AnalDiffist::FlogParser.new(file_name)
    end
    it 'should have an entry for the test method with a non zero score' do
      duplication = @problems.detect {|p| p.context == 'SmellyFile#duplication'}
      puts @problems.inspect
      duplication.score.should > 0
    end
  end
end
