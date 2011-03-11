require 'spec_helper'

describe AnalDiffist::TargetFinder do
  describe "#targets" do

    before { Dir.stub(:exists?){false} }

    subject { AnalDiffist::TargetFinder.new.targets }

    context 'when ./lib exists' do
      before { Dir.stub(:exists?).with('lib'){true} }
      it{should include("lib")}
    end

    context 'when ./app exists' do
      before { Dir.stub(:exists?).with('app'){true} }
      it{should include("app")}
    end

  end

  describe "#to_s" do
    subject do
      atf = AnalDiffist::TargetFinder.new.tap do |t|
        t.stub(:targets){['analyst', 'therapist']}
      end
      atf.to_s
    end

    it{ should == "analyst therapist"}
  end
end
