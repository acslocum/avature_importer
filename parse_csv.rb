require 'CSV'

class ParseCsv
  def initialize(filename)
    @filename = filename
  end
  
  def parse
    @csv = CSV.read(@filename)
    @csv[1..-1]
  end
  
  def headers
    @csv[0]
  end
  
end
