require 'litmus_resmail'
require 'savon_spec'

# TODO: put this config stuff in a helper file
RSpec.configure do |config|
  config.include Savon::Spec::Macros
  config.backtrace_clean_patterns = [
      /\/lib\d*\/ruby\//,
      /bin\//,
      #/gems/,
      /spec\/spec_helper\.rb/,
      /lib\/rspec\/(core|expectations|matchers|mocks)/
      ]
end
Savon.configure do |config|
  config.log = false    # turn off logging - for tests
end
fixtures = File.join(File.dirname(__FILE__), "fixtures")
Savon::Spec::Fixture.path = fixtures
litmus_wsdl = File.join(fixtures, 'litmus_wsdl.xml')


describe LitmusResmail::Analytics do
  let(:api) { LitmusResmail::Analytics.new('user', 'pw', litmus_wsdl) }

  it 'create should create a new report' do
    api = LitmusResmail::Analytics.new('user', 'pw')
    report = api.create
    report.should_not be_nil
    report.bugHtml.should_not be_nil
  end

  describe '#do_request' do
    it 'should call method and pass arguments' do
      savon.expects('GetEngagementReport').with(:user => 'user', :password => 'pw', :arg => 'some arg').returns
      api.do_request('GetEngagementReport', :arg => 'some arg')
    end

    it 'should peel off nested results' do
      savon.stubs('GetEngagementReport').returns(:all_zeroes)
      result = api.do_request('GetEngagementReport')
      result.should include(:glanced_or_unread_count)
    end
  end

  # merge the user_name and password into the 'with' clause to check args
  def api_expects(method, extra_args = {})
      args = { :user => 'user', :password => 'pw'}.merge(extra_args)
      savon.expects(method).with(args)
  end

  describe '#get_engagement_report' do
    it 'should pass campaignGuid parameter' do
      guid = 'a-g001d'
      api_expects('GetEngagementReport', 'campaignGuid' => guid).returns
      result = api.get_engagement_report(guid)
    end

    it 'should return an engagement report with many keys' do
      guid = 'a-g001d'
      savon.stubs('GetEngagementReport').returns(:all_zeroes)
      result = api.get_engagement_report(guid)
      result.size.should be >= 8
      result.should include(:glanced_or_unread_count)
    end
  end
end 
