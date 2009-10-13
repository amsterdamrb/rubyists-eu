require File.join(File.dirname(__FILE__), 'spec_helper')

describe User do
  context "when the data model have just been defined" do
    before :all do
      country = Country.new(:code => 'XX', :name => 'Test Country')
      
      country.save
    end
    
    before :each do
      User.destroy_all unless User.none?
    end
    
    it "should have no data" do
      User.should be_none
    end
    
    it "should allow to save a new user with properly pieces of data." do
      user = User.new(:name => 'Test User', :email => 'test@test.com', :openid => 'http://test.openid.com', 
                      :city => 'Test City', :country_code => 'XX')
                      
      user.should be_an_instance_of(User)
      user.id.should be_nil
      user.openid.should be_an_instance_of(String)
      user.name.should be_an_instance_of(String)
      user.name.should =~ PATTERN_NAME
      user.email.should be_an_instance_of(String)
      user.email.should =~ PATTERN_EMAIL
      user.city.should be_an_instance_of(String)
      user.city.should =~ PATTERN_NAME
      user.country_code.should be_an_instance_of(String)
      user.country_code.should =~ PATTERN_COUNTRY_CODE

      user.save
      
      saved_user = User.all.first
      
      saved_user.should be_an_instance_of(User)
      saved_user.openid.should == user.openid
      saved_user.name.should == user.name
      saved_user.email.should == user.email
      saved_user.city.should == user.city
      saved_user.country_code.should == user.country_code
    end
    
    it "should not save a new user when any piece of data does not match de defined criteria." do
      users = [{:name => nil, :openid => nil, :email => nil, :city => nil, :country_code => nil},
               {:name => 'User', :openid => nil, :email => nil, :city => nil, :country_code => nil}, 
               {:name => 'User', :openid => 'http://user.openid.com', :email => nil, :city => nil, :country_code => nil}, 
               {:name => 'User', :openid => 'http://user.openid.com', :email => 'user', :city => nil, :country_code => nil}, 
               {:name => 'User', :openid => 'http://user.openid.com', :email => '6user@xxx.com', :city => nil, :country_code => nil}, 
               {:name => 'User', :openid => 'http://user.openid.com', :email => '-test@xxx.com', :city => nil, :country_code => nil},
               {:name => 'User', :openid => 'http://user.openid.com', :email => '_test@xxx.com', :city => nil, :country_code => nil}, 
               {:name => 'User', :openid => 'http://user.openid.com', :email => 'test@xxx.com', :city => '2nd', :country_code => nil}, 
               {:name => 'User', :openid => 'http://user.openid.com', :email => 'test@xxx.com', :city => 'city', :country_code => nil},
               {:name => 'User', :openid => 'http://user.openid.com', :email => 'test@xxx.com', :city => 'Test -city', :country_code => nil}, 
               {:name => 'User', :openid => 'http://user.openid.com', :email => 'test@xxx.com', :city => 'City', :country_code => 'X'}, 
               {:name => 'User', :openid => 'http://user.openid.com', :email => 'test@xxx.com', :city => 'City', :country_code => 'Xx'}, 
               {:name => 'User', :openid => 'http://user.openid.com', :email => 'test@xxx.com', :city => 'City', :country_code => 'XXX'}]
               
      users.each do |user|
        test_user = User.new(:name => user[:name], :openid => user[:openid], :email => user[:email], 
                             :city => user[:city], :country_code => user[:country_code])
        
        unless user[:name].nil?
          test_user.name.should be_an_instance_of(String)
          (user[:name] =~ PATTERN_NAME).nil? ? test_user.name.should_not =~ PATTERN_NAME :
                                               test_user.name.should =~ PATTERN_NAME
        end
        
        unless user[:openid].nil?
          test_user.openid.should be_an_instance_of(String)
        end
        
        unless user[:email].nil?
          test_user.email.should be_an_instance_of(String)
          (user[:email] =~ PATTERN_EMAIL).nil? ? test_user.email.should_not =~ PATTERN_EMAIL :
                                                 test_user.email.should =~ PATTERN_EMAIL
        end
        
        unless user[:city].nil?
          test_user.city.should be_an_instance_of(String)
          (user[:city] =~ PATTERN_NAME).nil? ? test_user.city.should_not =~ PATTERN_NAME :
                                               test_user.city.should =~ PATTERN_NAME
        end
        
        unless user[:country_code].nil?
          test_user.country_code.should be_an_instance_of(String)
          (user[:country_code] =~ PATTERN_COUNTRY_CODE).nil? ? test_user.country_code.should_not =~ PATTERN_COUNTRY_CODE :
                                                               test_user.country_code.should =~ PATTERN_COUNTRY_CODE
        end
        
        test_user.save
        
        User.should be_none
      end
    end
  end
end