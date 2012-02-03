require 'hashie'
require 'savon'

module LitmusResmail
  class Analytics
    def initialize(user, password, wsdl_file = nil)
      @user = user
      @password = password

      # could make this a factory method to aid in mocking/stubbing
      @client = Savon::Client.new do
         if wsdl_file
           wsdl.document = wsdl_file
          else
            wsdl.endpoint = "http://queue-production-448133392.us-east-1.elb.amazonaws.com/fingerprint/apiservice.asmx"
            wsdl.namespace = "http://ea-api.litmus.com"
          end
      end
    end

    # Conflusingly (by their own admission), what most people would call a
    # campaign, Litmus calls a "report".
    def create()
      result = Hashie::Mash.new(:bugHtml => '<em>tracking bug goes here</em>',
                                :guid => Time.now.to_s,
                                :reportGuid => "report of #{Time.now}",
                                :individual => false)
    end

    def get_engagement_report(guid)
      do_request('GetEngagementReport', 'campaignGuid' => guid)
    end

    def do_request(method, arg_hash = {})
      args = { :user => @user, :password => @password }.merge(arg_hash)
      response = @client.request(method) do
        soap.body = args
      end

      # not sure (yet) what more to do for error checking,
      return response if response.to_xml.empty?       # happens when mocking with savon-spec

      # strip off method_response and method_result wrappers
      resp_key = "#{method.to_s.snakecase}_response".to_sym
      res_key = "#{method.to_s.snakecase}_result".to_sym

      response[resp_key][res_key]
    end
  end
end

