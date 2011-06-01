require  'spec_helper'

RSpec::Matchers.define :have_a_single_problem do |type, context|
  match do |problems|
    problems.length.should == 1
    problems.first.type.should == type
    problems.first.context.should == context
  end
end

describe 'diffing two files' do
  context 'single problem added' do
    subject{AnalDiffist::DiffSet.new([], [test_problem('foo', 'bar')])}

    its(:removed_problems) {should == []}
    its(:added_problems) {should  have_a_single_problem 'foo', 'bar'}
  end

  context 'single problem removed' do
    subject { AnalDiffist::DiffSet.new( [test_problem('foo', 'bar')], [])}

    its(:removed_problems) {should have_a_single_problem 'foo', 'bar' }
    its(:added_problems) {should == []}
  end

  context 'one removed, one added, one remains' do
    subject do
      before = [test_problem('foo', 'bar'), test_problem('removed', 'removed')]
      after = [test_problem('foo', 'bar'), test_problem('added', 'added')]
      AnalDiffist::DiffSet.new(before, after)
    end

    its(:removed_problems) {should  have_a_single_problem 'removed', 'removed'}
    its(:added_problems) {should have_a_single_problem 'added', 'added'}
  end

  context 'reeks are grouped by context and type' do
    context 'two reeks with same context and type, then one is removed' do
      subject do
        before = [test_problem('same-type', 'bar'), test_problem('same-type', 'bar')]
        after = [test_problem('same-type', 'bar')]
        AnalDiffist::DiffSet.new(before, after)
      end

      its(:removed_problems) {should  have_a_single_problem 'same-type', 'bar'}
      its(:added_problems) {should == []}
    end

    context 'two reeks with same context and different type, then one is removed' do
      subject do
        before = [test_problem('other-type', 'bar')]
        after = [test_problem('same-type', 'bar')]
        AnalDiffist::DiffSet.new(before, after)
      end

      its(:removed_problems) {should  have_a_single_problem 'other-type', 'bar'}
      its(:added_problems) {should  have_a_single_problem 'same-type', 'bar'}
    end
  end

  context 'when scores change' do
    subject do
      before = [AnalDiffist::FlogProblem.new('bar', 17.1)]
      after = [AnalDiffist::FlogProblem.new('bar', 18.5)]
      AnalDiffist::DiffSet.new(before, after).added_problems
    end
    specify {subject.should have(1).item}
    specify {subject.first.score.should == 1.4 }
  end

  context 'removing a flog' do
    subject do
      before = [AnalDiffist::FlogProblem.new('bar', 18.1)]
      after = [AnalDiffist::FlogProblem.new('bar', 8.5)]
      AnalDiffist::DiffSet.new(before, after)
    end
    specify {subject.added_problems.should have(0).problems}
    specify {subject.removed_problems.should have(1).item}
    specify {subject.removed_problems.first.score.should == -9.6 }
  end

  def test_problem type, context, score = 1
    smell = double("fake problem")
    smell.stub(:subclass) {type}
    smell.stub(:location) { {"context" => context} }
    return AnalDiffist::ReekProblem.new(smell)
  end
end
