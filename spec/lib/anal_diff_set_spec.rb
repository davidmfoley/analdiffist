require  'spec_helper'
require 'anal_diff_set'

describe 'diffing two files' do
  context 'single problem added' do
    before do
      @diff = AnalDiffSet.new([], [test_problem('foo', 'bar')])
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
      @diff = AnalDiffSet.new( [test_problem('foo', 'bar')], [])
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
      @diff = AnalDiffSet.new(before, after)
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

  def test_problem type, context
    double('fake problem').tap do |p|
      p.stub(:type) {type}
      p.stub(:context) {context}
    end
  end
end
