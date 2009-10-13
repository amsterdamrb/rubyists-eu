class Country
  include DataMapper::Resource
  extend Rubyists::Resource
  
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
