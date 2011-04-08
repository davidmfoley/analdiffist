require 'spec_helper'

describe AnalDiffist::StdOutReporter do
  before do
    problems = [
      fake_problem('SomeType#foo', 1, 'A'),
      fake_problem('SomeType#foo', 2, 'B'),
      fake_problem('SomeType#bar', 3, 'C'),
      fake_problem('XXXXSomeOtherType#foobar', 4, 'D'),
    ]
    @results = AnalDiffist::StdOutReporter.new.describe(problems, :added)
  end

  it 'should have a header for the type' do
    @results.first.should == "  SomeType"
  end

  it 'should have an entry for the method' do
    @results[1].should == "    #bar"
  end

  it 'should have an entry for each problem' do
    @results[2].should == "      C"
  end

  def fake_problem(context, score, description) 
    stub('fake problem').tap {|problem| 
      problem.stub(:context) {context}
      problem.stub(:description) {description}
    }
  end
end

