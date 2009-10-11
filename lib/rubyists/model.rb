require 'dm-core'
require 'dm-validations'
require 'dm-aggregates'

DataMapper.setup :default, (ENV['DATABASE_URL'] || "postgres://postgres:postgres@localhost/rubyists")

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

#class Member
#  include DataMapper::Resource
#
#  property :id, Serial
#  property :openid, String
#  property :name, String
#  property :city, String
#  property :country, String
#
#  def self.seed
#    return if count > 0
#    member = new
#
#    member.openid = "Hola"
#    member.name = "Javier Cicchelli"
#    member.city = "Buenos Aires"
#    member.country = "Argentina"
#
#    member.save
#  end
#end
#
#class UserGroup
#  include DataMapper::Resource
#
#  property :id, Serial
#  property :name, String
#  property :city, String
#  property :country, String
#
#  def self.seed
#    {
#      'Amsterdam.rb' => {:city => 'Amsterdam', :country => 'The Netherlands'},
#      'Utrecht.rb' => {:city => 'Utrecht', :country => 'The Netherlands'},
#      'Den Haag.rb' => {:city => 'Den Haag', :country => 'The Netherlands'},
#    }.each do |name, attrs|
#      next if count(:name => name) > 0
#      ug = new
#
#      ug.name = name
#      ug.city = attrs[:city]
#      ug.country = attrs[:country]
#
#      ug.save
#    end
#  end
#
#  def to_json
#    attributes.to_json
#  end
#end
#
#class DataMapper::Collection
#  def to_json
#    to_a.to_json
#  end
#end

DataMapper.auto_migrate!

Country.populate
#Member.seed
#UserGroup.seed