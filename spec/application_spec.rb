require File.join(File.dirname(__FILE__), 'spec_helper')

describe "Application" do
  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
end