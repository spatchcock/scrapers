require 'nokogiri'
require 'open-uri'
require 'date'


SOURCE_URL = "http://www.pol.ac.uk/ntslf/tides/?port=0049"

ELEVATION_REGEX = /([\d.,]+).*(H|L)/
DATE_REGEX      = /\w{3}\s(\d+)\w*(\s\w{3}\s\d{4})?$/

def parse_days(doc)
  days = doc.css("table")[1].css("tr") and days.shift          # Parse tide data table and lose copyright statement
  return days
end

def parse_and_format_date(day)   
  cell = day.css("td").shift and cell.unlink                   # remove date reference from day object                  
  DATE_REGEX.match(cell.text)                                  # parse day and, if matched, month and year from string
  $current_month_and_year = $2 if $2                           # reset the month and year if matched
  return Date.parse("#{$1} #{$current_month_and_year}") if $1
end

def parse_and_format_benchmarks(day)
  # remove any blank cells (some days only contain 3 tidal maxima/minima)

  benchmarks = day.css("td").select { |b| !b.css("span").text.strip.empty? }
  benchmarks.map {|b| parse_elevation_and_time(b) }
end

def parse_elevation_and_time(benchmark)
   
  # parse and format elevation data
  # remove the nested span from the cell to enable clean parsing of time
  # get time and strip trailing whitespace

  data = {}
  data['elevation'] = format_elevation(benchmark.css("span").text) and benchmark.css("span").unlink
  data['time']      = benchmark.text.strip      

  return data
end

def format_elevation(string)             
  ELEVATION_REGEX.match(string)    # parse the number and the phase (high, low) from string
  number, phase = $1.to_f, $2
  number *= -1 if phase == 'L'     # convert elevation to a negative value for low phase elevations
  return number
end


# execute
doc     = Nokogiri::HTML(open(SOURCE_URL))
records = []

parse_days(doc).each do |day|
  
  date = parse_and_format_date(day)

  parse_and_format_benchmarks(day).each do |benchmark|
    benchmark.merge!('date' => date)
    records << benchmark 
  end
end

# Just print to a basic, tab delimited file
File.open('millport_tides.csv', 'w') do |file|
  file.write "date\t\ttime\televation (m)\n"
  records.each do |r|

    # Add some whitespace to format column justification (to accomodate minus signs)
    if r['elevation'] > 1
      r['elevation'] = " #{r['elevation']}"
    end

    file.write "#{r['date']}\t#{r['time']}\t#{r['elevation']}\n"
  end
end