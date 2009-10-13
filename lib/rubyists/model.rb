require 'dm-core'
require 'dm-validations'
require 'dm-aggregates'

class Country
  include DataMapper::Resource
  
  has 1, :user
  
  property :code, String, :length => 2, :format => /^[A-Z]{2}$/, :key => true
  property :name, String, :nullable => false

  class << self
    def populate
      File.open("#{Dir.pwd}/data/countries.csv", File::RDONLY).each_line do |row|
        country = Country.new

        country.name = ""
        name, code = row.split(';')
        name.downcase!.split(' ').each{|fraction| country.name << "#{fraction.capitalize} "}
        country.name.chop!
        country.code = code[0, 2]

        country.save
      end
    end
  end
end

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
