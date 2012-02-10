require 'spec_helper'

describe AnalDiffist::StandardDiffist do
  class FakeParser
    def initialize opts
    end

    def problems
      []
    end
  end

  it 'should work' do
    @diffist = AnalDiffist::StandardDiffist.new :parsers => [FakeParser]
    @diffist.do_analytics('foo')
    @diffist.do_analytics('bar')
  end

  it 'should work!' do
    @diffist = AnalDiffist::StandardDiffist.new
    @diffist.do_analytics('foo')
    @diffist.do_analytics('bar')
  end
end
