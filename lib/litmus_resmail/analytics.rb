require 'hashie'

module LitmusResmail
  class Analytics
    # Conflusingly (by their own admission), what most people would call a
    # campaign, Litmus calls a "report".
    def create()
      result = Hashie::Mash.new(:bugHtml => '<em>tracking bug goes here</em>',
                                :guid => Time.now.to_s,
                                :reportGuid => "report of #{Time.now}",
                                :individual => false)
    end
  end
end

