require  'spec_helper'
RSpec::Matchers.define :have_a_single_problem do |type, context|
  match do |problems|
    puts type
    puts context
    puts problems.first.inspect
    problems.length.should == 1
    problems.first.type.should == type
    problems.first.context.should == context
  end
end

describe 'diffing two files' do
  context 'single problem added' do
    before do
      @diff = AnalDiffist::DiffSet.new([], [test_problem('foo', 'bar')])
    end
    it 'should find a new reek' do
      @diff.added_problems.should have_a_single_problem('foo', 'bar')
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
      @diff.removed_problems.should have_a_single_problem 'foo', 'bar'
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
      @diff.removed_problems.should have_a_single_problem 'removed', 'removed'
    end

    it 'should find an added problem' do
      @diff.added_problems.should have_a_single_problem 'added', 'added'
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
    smell.stub(:location) { {"context" => context} }
    return AnalDiffist::ReekProblem.new(smell)
  end
end
