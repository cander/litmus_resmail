require 'spec_helper'
require 'litmus_resmail'


describe LitmusResmail::Analytics do
  litmus_wsdl = File.join(Savon::Spec::Fixture.path, 'litmus_wsdl.xml')
  let(:api) { LitmusResmail::Analytics.new('user', 'pw', litmus_wsdl) }

    # NB: we have to use strings (with capital First Letter) when testing with
    # saveon-spec even though we use :symbols in the savon requests.

  describe '#do_request' do
    it 'should call method and pass arguments' do
      savon.expects('GetEngagementReport').with(:user => 'user', :password => 'pw', :arg => 'some arg').returns
      api.do_request('GetEngagementReport', :arg => 'some arg')
    end

    it 'should peel off nested results' do
      savon.stubs('GetEngagementReport').returns(:all_zeroes)
      result = api.do_request('GetEngagementReport')
      result.glanced_or_unread_count.should_not be_nil
    end
  end

  # merge the user_name and password into the 'with' clause to check args
  def api_expects(method, extra_args = {})
      args = { :user => 'user', :password => 'pw'}.merge(extra_args)
      savon.expects(method).with(args)
  end


  describe '#create' do
    it 'should return IDs and HTML for a new compaign' do
      savon.stubs('Create').returns(:dummy)
      result = api.create
      result.bug_html.should_not be_nil
      result.guid.should_not be_nil
      result.report_guid.should_not be_nil
    end
  end

  describe '#start_campaign' do
    it 'should pass campaignGuid parameter' do
      guid = 'a-g001d'
      api_expects('StartCampaign', 'campaignGuid' => guid).returns
      result = api.start_campaign(guid)
    end

    it 'should return IDs and HTML for a new compaign' do
      guid = 'a-g001d'
      savon.stubs('StartCampaign').returns(:success)
      result = api.start_campaign(guid)
    end
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
