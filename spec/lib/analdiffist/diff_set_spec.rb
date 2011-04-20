require  'spec_helper'

describe 'diffing two files' do
  context 'single problem added' do
    before do
      @diff = AnalDiffist::DiffSet.new([], [test_problem('foo', 'bar')])
    end
    it 'should find a new reek' do
      added_problems = @diff.added_problems
      added_problems.length.should == 1
      added_problems.first.type.should == 'foo'
      added_problems.first.context == 'bar'
    end
    it 'should not have any removed reeks' do
      @diff.removed_problems.should == []
    end
  end

  context 'single problem removed' do
    before do
      @diff = AnalDiffist::DiffSet.new( [test_problem('foo', 'bar')], [])
    end
    it 'should find a removed reek' do
      removed_problems = @diff.removed_problems
      removed_problems.length.should == 1
      removed_problems.first.type.should == 'foo'
      removed_problems.first.context == 'bar'
    end
    it 'should not have any added reeks' do
      @diff.added_problems.should == []
    end
  end

  context 'one removed, one added, one remains' do
    before do
      before = [test_problem('foo', 'bar'), test_problem('removed', 'removed')]
      after = [test_problem('foo', 'bar'), test_problem('added', 'added')]
      @diff = AnalDiffist::DiffSet.new(before, after)
    end

    it 'should find a removed reek' do
      removed_problems = @diff.removed_problems
      removed_problems.length.should == 1
      removed_problems.first.type.should == 'removed'
      removed_problems.first.context == 'removed'
    end

    it 'should find an added problem' do
      added_problems = @diff.added_problems
      added_problems.length.should == 1
      added_problems.first.type.should == 'added'
      added_problems.first.context == 'added'
    end
  end

  context 'two reeks with same context and type, then one is removed' do
    before do
      before = [test_problem('same-type', 'bar'), test_problem('same-type', 'bar')]
      after = [test_problem('same-type', 'bar')]
      @diff = AnalDiffist::DiffSet.new(before, after)
    end

    it 'should show one removed problem' do
      @diff.removed_problems.length.should ==1
    end

    it 'should have zero added problems' do
      @diff.added_problems.length.should == 0
    end
  end

  context 'when scores change' do
    before do
      before = [AnalDiffist::FlogProblem.new('bar', 17.1)]
      after = [AnalDiffist::FlogProblem.new('bar', 18.5)]
      @diff = AnalDiffist::DiffSet.new(before, after)
    end

    it 'should identify as added' do
      added_problems = @diff.added_problems
      added_problems.length.should == 1
      added_problems.first.score.round(1).should == 1.4
    end
  end

  def test_problem type, context, score = 1
    smell = double("fake problem")
    smell.stub(:subclass) {type}
    smell.stub(:location) {context}
    return AnalDiffist::ReekProblem.new(smell)

    double('fake problem').tap do |p|
      p.stub(:type) {type}
      p.stub(:context) {context}
      p.stub(:score) {score}
      p.stub(:diff) {p}
    end
  end
end
