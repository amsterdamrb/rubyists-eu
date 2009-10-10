require File.join(File.dirname(__FILE__), 'spec_helper')

describe Country do
  context "when the data model have been defined" do
    before :all do
      Country.all.each{|country| country.destroy} \
        unless Country.all.empty?
    end
    
    it "should have no data." do
      Country.all.size.should == 0
    end
    
    it "should populate its possible values from a comma-separated file." do
      Country.populate
      Country.all.size.should > 0
    end
  end
end
