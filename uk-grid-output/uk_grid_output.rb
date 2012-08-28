require 'rexml/document'
require 'net/http'

include REXML

# Get and parse data from www.bmreports.com
url = "http://www.bmreports.com/bsp/additional/soapfunctions.php?element=generationbyfueltypetable"
xml = Net::HTTP.get_response(URI.parse(url))
doc = REXML::Document.new(xml.body)

# Initialize hash to store retrieved data
data = {}

# Add timestamp and aggregate power output
data['DATE'] = "#{doc.elements["GENERATION_BY_FUEL_TYPE_TABLE/LAST24H/@FROM_SD"]}"
data['TOTAL'] = "#{doc.elements["GENERATION_BY_FUEL_TYPE_TABLE/LAST24H/@TOTAL"]}"

# Add power output for each fuel type to hash
doc.elements["GENERATION_BY_FUEL_TYPE_TABLE/INST"].each do |entry|
  data["#{REXML::XPath.first(entry,'@TYPE')}"] = "#{REXML::XPath.first(entry,'@PCT')}"
end

# do something with data

data.each do |datum|
  puts "#{datum.first}\t#{datum.last}"
end



