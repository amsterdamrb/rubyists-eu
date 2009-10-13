module Rubyists
  module Resource
    def destroy_all
      all.each {|model| model.destroy}
    end

    def none?
      count == 0
    end
  end
end
