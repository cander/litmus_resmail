require 'hashie'
require 'savon'

module LitmusResmail
  class Analytics
    def initialize(user, password, wsdl_file = nil)
      @user = user
      @password = password
      # could make this a factory method to aid in mocking/stubbing
      @client = Savon::Client.new do
         # set the wsdl.endpoint if no file
         wsdl.document = wsdl_file if wsdl_file
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
    end

    def do_request(method, arg_hash = {})
      args = { :user => @user, :password => @password }
      args.merge!(arg_hash)
      puts "calling #{method} with #{args.inspect}"
      response = @client.request(method) do
        soap.body = args
      end

      # not sure what more to do for error checking, yet
      return response if response.to_xml.empty?       # happens when mocking with savon-spec

      # strip off method_response and method_result wrappers
      resp_key = "#{method.to_s.snakecase}_response".to_sym
      res_key = "#{method.to_s.snakecase}_result".to_sym

      response[resp_key][res_key]
    end
  end
end

