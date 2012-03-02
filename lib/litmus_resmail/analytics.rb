require 'hashie'
require 'savon'

module LitmusResmail
  class Analytics
    def initialize(user, password, wsdl_file)
      @user = user
      @password = password

      # could make this a factory method to aid in mocking/stubbing
      @client = Savon::Client.new do
         if wsdl_file
           wsdl.document = wsdl_file
          else
            # bug-let: wsdl_file used to be optional, but the case of the first
            # character of method names ends up lower-cased, which doesn't work.
            # should fix that
            wsdl.endpoint = "http://queue-production-448133392.us-east-1.elb.amazonaws.com/fingerprint/apiservice.asmx"
            wsdl.namespace = "http://ea-api.litmus.com"
          end
      end
    end

    # NB: for some reason, we have to use :method_names as symbols instead
    # of strings in order to get the right SOAP header generated.
    # Luckily, savon does capitalize the first letter of the method name correctly

    # campaign management

    def create
      do_request(:create)
    end

    def get_campaign_meta_data(guid)
      do_request(:get_campaign_meta_data, 'campaignGuid' => guid)
    end

    def start_campaign(guid)
      response = send_request(:start_campaign, 'campaignGuid' => guid)

      return response if response.to_xml.empty?       # happens when mocking with savon-spec

      response[:start_campaign_response][:start_campaign_result]
    end

    # activity/engagement reports

    def get_activity_report(guid)
      # returns an empty result - wtf?
      do_request(:get_activity_report, 'campaignGuid' => guid)
    end

    def get_activity_summary_report(guid)
      do_request(:get_activity_summary_report, 'campaignGuid' => guid)
    end

    def get_detailed_engagement_report(guid)
      do_request(:get_detailed_engagement_report, 'campaignGuid' => guid)
    end

    def get_email_client_usage_report(guid)
      # returns an empty result - wtf?
      do_request(:get_email_client_usage_report, 'campaignGuid' => guid)
    end

    def get_engagement_report(guid)
      do_request(:get_engagement_report, 'campaignGuid' => guid)
    end

    def get_group_usage_report(guid)
      do_request(:get_group_usage_report, 'campaignGuid' => guid)
    end

    def get_mail_client_engagement_report(guid)
      do_request(:get_mail_client_engagement_report, 'campaignGuid' => guid)
    end

    def get_open_counts(guid1, guid2)
      # this will require manually building up the XML -ugh
      # TODO: break the response unpacking out of do_request
      # do_request(:get_open_counts, 'campaignGuids' => [guid1, guid2])
      raise "get_open_counts is not implemented, yet"
    end

    def get_rendering_category_report(guid)
      # returns an empty result - wtf?
      do_request(:get_rendering_category_report, 'campaignGuid' => guid)
    end


    # internal methods

    def do_request(method, arg_hash = {})
      response = send_request(method, arg_hash)

      # not sure (yet) what more to do for error checking,
      return response if response.to_xml.empty?       # happens when mocking with savon-spec

      extract_result(method, response)
    end

    def send_request(method, arg_hash = {})
      args = { :user => @user, :password => @password }.merge(arg_hash)
      response = @client.request(method) do
        soap.body = args
      end

      response
    end

    # strip off method_response and method_result wrappers and package in a hashie
    def extract_result(method, response)
      resp_key = "#{method.to_s.snakecase}_response".to_sym
      res_key = "#{method.to_s.snakecase}_result".to_sym

      Hashie::Mash.new(response[resp_key][res_key])
    end
  end
end

