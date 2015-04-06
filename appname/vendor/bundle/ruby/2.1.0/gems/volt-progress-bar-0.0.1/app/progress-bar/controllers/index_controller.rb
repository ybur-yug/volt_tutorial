module ProgressBar
  class IndexController
    def initialize(data)
      @data = data
      if !@data.locals.has_key?("value")
        raise "Progress Bar requires a value."
      end
      if !@data.locals.has_key?("total")
        raise "Progress Bar requires a total."
      end
    end
    
    def width
      w = @data.value.to_f / @data.total.to_f * 100
      w.with {|v| [[v, 0].max, 100].min } 
    end
    
    def classes
      if @data.locals.has_key?("classes")
        @data.classes 
      else
        ""
      end
    end
  end
end