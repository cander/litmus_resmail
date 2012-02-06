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

    # NB: for some reason, we have to use :method_names as symbols instead
    # of strings in order to get the right SOAP header generated.
    # Luckily, savon does capitalize the first letter of the method name correctly

    def create
      do_request(:create)
    end

    def get_engagement_report(guid)
      do_request(:get_engagement_report, 'campaignGuid' => guid)
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

      Hashie::Mash.new(response[resp_key][res_key])
    end
  end
end

