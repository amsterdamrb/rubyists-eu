require File.join(File.dirname(__FILE__), 'spec_helper')

describe Country do
  context "when the data model have been just defined" do
    before :each do
      Country.all.each{|country| country.destroy} \
        unless Country.all.empty?
    end
    
    it "should have no data." do
      Country.all.size.should == 0
    end
    
    it "should allow to save a new country with a defined 2-letter uppercased code and a name." do
      country = Country.new(:code => 'XX', :name => 'Test Country')
      
      country.should be_an_instance_of(Country)
      country.code.should be_an_instance_of(String)
      country.code.should =~ /^[A-Z]{2}$/
      country.code.length.should == 2
      country.name.should be_an_instance_of(String)
      
      country.save
      
      saved_country = Country.get(country.code)
      
      saved_country.should be_an_instance_of(Country)
      saved_country.code.should == country.code
      saved_country.name.should == country.name
    end
    
    it "should not save a new country with a defined 2-letter uppercased code and a nil name." do
      country = Country.new(:code => 'XX')
      
      country.should be_an_instance_of(Country)
      country.code.should be_an_instance_of(String)
      country.code.should =~ /^[A-Z]{2}$/
      country.code.length.should == 2
      country.name.should be_nil
      
      country.save
      
      Country.get(country.code).should be_nil
    end
    
    it "should not save a new country with a 2-letter lowercased code and a name." do
      country = Country.new(:code => 'xx', :name => 'Test Country')
      
      country.should be_an_instance_of(Country)
      country.code.should be_an_instance_of(String)
      country.code.should_not =~ /^[A-Z]{2}$/
      country.code.length.should == 2
      country.name.should be_an_instance_of(String)
      
      country.save
      
      Country.get(country.code).should be_nil
    end
    
    it "should not save a new country with a 2-letter mixed code and a name." do
      country = Country.new(:code => 'Xx', :name => 'Test Country')
      
      country.should be_an_instance_of(Country)
      country.code.should be_an_instance_of(String)
      country.code.should_not =~ /^[A-Z]{2}$/
      country.code.length.should == 2
      country.name.should be_an_instance_of(String)
      
      country.save
      
      Country.get(country.code).should be_nil
    end
    
    it "should not save a new country with an alphanumeric code and a name." do
      country = Country.new(:code => 'X0', :name => 'Test Country')
      
      country.should be_an_instance_of(Country)
      country.code.should be_an_instance_of(String)
      country.code.should_not =~ /^[A-Z]{2}$/
      country.code.length.should == 2
      country.name.should be_an_instance_of(String)
      
      country.save
      
      Country.get(country.code).should be_nil
    end
    
    it "should not save a new country with a nil code and a name." do
      country = Country.new(:name => 'Test Country')
      
      country.should be_an_instance_of(Country)
      country.code.should be_nil
      country.name.should be_an_instance_of(String)
      
      country.save
      
      Country.get(country.code).should be_nil
    end
    
    it "should populate its possible values from a comma-separated file." do
      Country.populate
      Country.all.size.should > 0
    end
  end
end
