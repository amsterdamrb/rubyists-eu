module DataMapper
  module Resource
    def to_json
      attributes.to_json
    end
  end
  
  class Collection
    def to_json
      to_a.to_json
    end
  end
end