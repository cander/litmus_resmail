require 'savon_spec'

RSpec.configure do |config|
  config.include Savon::Spec::Macros

  # allow gems to show up in the traceback of a failed test
  # useful for figuring out why things break in savon/savon-spec
  config.backtrace_clean_patterns = [
      /\/lib\d*\/ruby\//,
      /bin\//,
      #/gems/,
      /spec\/spec_helper\.rb/,
      /lib\/rspec\/(core|expectations|matchers|mocks)/
      ]
end

Savon.configure { |cfg| cfg.log = false }    # turn off SOAP logging - for tests
Savon::Spec::Fixture.path = File.join(File.dirname(__FILE__), "fixtures")

