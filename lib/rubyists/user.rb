class User
  include DataMapper::Resource
  
  belongs_to :country
  
  property :id, Serial
  property :openid, String, :nullable => false
  property :name, String, :nullable => false, :format => /^([A-Z][a-z\.\-]*\s?)+$/
  property :email, String, :nullable => false, :format => /^(?:[a-z]+)(\.[\w\-]+)*@([\w\-]+)(\.[\w\-\.]+)*(\.[a-z]{2,4})$/i   
  property :city, String, :nullable => false, :format => /^([A-Z][a-z\.\-]*\s?)+$/
  
  before :save do
    throw :halt if Country.get(country_code).nil?
  end
end
