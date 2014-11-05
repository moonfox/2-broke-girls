require File.expand_path("../../lib/broke_girls" ,__FILE__)

class Subtitle
  def initialize(obj)
    @obj = obj
  end

  def generate
    @obj.generate_subtitle
  end  
end