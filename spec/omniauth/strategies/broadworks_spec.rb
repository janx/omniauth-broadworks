require File.expand_path('../../../spec_helper', __FILE__)

describe OmniAuth::Strategies::Broadworks do
  def app; lambda {|env| [200, {}, ["Hello HttpBasic!"]]}; end

  let(:fresh_strategy) { Class.new OmniAuth::Strategies::Broadworks }
  subject { fresh_strategy }

  it 'should be initialized with XSI endpoint and sip domain' do
    instance = subject.new(app, "http://www.example.com/xsi", "xdp.broadsoft.com")
    instance.options.endpoint.should == "http://www.example.com/xsi"
    instance.options.domain.should   == "xdp.broadsoft.com"
  end
end
