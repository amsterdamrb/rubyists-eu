class Group
  include DataMapper::Resource
  extend Rubyists::Resource

  property :id, Serial
end
