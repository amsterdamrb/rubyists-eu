class Group
  include DataMapper::Resource
  extend Rubyists::Resource

  property :id, Serial
  property :name, String, :nullable => false, :format => /^([A-Z][a-z\.\-]*\s?)+$/
  property :city, String, :nullable => false, :format => /^([A-Z][a-z\.\-]*\s?)+$/
  property :country, String, :nullable => false, :format => /^([A-Z][a-z\.\-]*\s?)+$/
end
