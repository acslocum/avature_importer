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

#https://jobs.thoughtworks.com/synapserWait?applicationCode=iats&version=3dbb1e&pageSessionId=1806603102
#
#{"m":
#  [
#    ["Stag_Tag.linkToEntityId",
#      [
#        {"tagName":"asdfsadg","entityType":"contact","entityId":285694}
#      ]
#    ]
#  ],
#"p":"nmDv17JxQ.xHc4fYBlNuZ.OYIMFL",
#"c":"iatsSharedSESSID"
#}
