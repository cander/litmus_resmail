require 'litmus_resmail'

describe LitmusResmail::Analytics do
  it 'create should create a new report' do
    api = LitmusResmail::Analytics.new('user', 'pw')
    report = api.create
    report.should_not be_nil
    report.bugHtml.should_not be_nil
  end
end 
