require File.expand_path('../../../spec_helper', __FILE__)

RESPONSE_XML = <<EOF
<?xml version="1.0" encoding="iso-8859-1"?>
<Profile xmlns="http://schema.broadsoft.com/xsi">
  <details>
    <userId>Test1234User1@xdp.broadsoft.com</userId>
    <firstName>Test1234</firstName>
    <lastName>User1</lastName>
    <groupId>Test1234Group</groupId>
    <serviceProvider isEnterprise="true">Test1234Ent</serviceProvider>
    <number>1234567890</number>
    <extension>1234</extension>
  </details>
  <additionalDetails />
  <passwordExpiresDays>2147483647</passwordExpiresDays>
  <fac>/v2.0/user/Test1234User1@xdp.broadsoft.com/profile/Fac</fac>
  <registrations>
  /v2.0/user/Test1234User1@xdp.broadsoft.com/profile/Registrations</registrations>
  <scheduleList>
  /v2.0/user/Test1234User1@xdp.broadsoft.com/profile/Schedule</scheduleList>
  <portalPasswordChange>
  /v2.0/user/Test1234User1@xdp.broadsoft.com/profile/Password/Portal</portalPasswordChange>
  <countryCode>1</countryCode>
</Profile>
EOF

describe OmniAuth::Strategies::Broadworks do
  def app; lambda {|env| [200, {}, ["Hello HttpBasic!"]]}; end

  let(:fresh_strategy) { Class.new OmniAuth::Strategies::Broadworks }
  let(:instance) { subject.new(app, "http://www.example.com/xsi", :domain => "xdp.broadsoft.com") }
  subject { fresh_strategy }

  it 'should be initialized with XSI endpoint and sip domain' do
    instance.options.endpoint.should == "http://www.example.com/xsi"
    instance.options.domain.should   == "xdp.broadsoft.com"
  end

  it 'should set auth hash' do
    xml = Nokogiri.XML(RESPONSE_XML)
    instance.stub!(:request).and_return({'username' => 'test1234', 'password' => '1234'})
    instance.stub!(:xml_response).and_return(xml)
    instance.uid.should == "Test1234User1@xdp.broadsoft.com"
    instance.credentials[:username].should == 'test1234@xdp.broadsoft.com'
    instance.info[:name].should == 'Test1234 User1'
    instance.extra[:number].should == '1234567890'
  end
end
