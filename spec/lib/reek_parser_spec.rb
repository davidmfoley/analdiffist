require 'reek_metrics'
require 'reek_parser'

describe ReekParser do
  context 'a smelly file' do
    before do
      smelly_file_parser = get_parser_for('smelly_file.rb')
      @problems = smelly_file_parser.problems
    end

    it 'has a duplication warning for the duplication method' do
      smells = get_smells_for('SmellyFile#duplication')
      smells[0].type.should == 'DuplicateMethodCall'
    end

    it 'should have some results' do
      @problems.length.should > 0
    end

    it 'creates a diff' do
      smelly_file_parser = get_parser_for('smelly_file.rb')
      other_smelly_file_parser = get_parser_for('other_smelly_file.rb')
      diff = smelly_file_parser.diff(other_smelly_file_parser)
      diff.should be
    end

    def get_smells_for context
      @problems.select {|reek| reek.context == context}
    end
  end

  def get_parser_for(fixture_file)
    file_name = File.join(File.dirname(__FILE__), '../fixtures/', fixture_file)
    ReekParser.new([file_name])
  end
end
