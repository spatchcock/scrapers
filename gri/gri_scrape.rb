# This script iterates though the RESTful records of the Global Reporting Initiative site and
# attempts to download company sustainability reports. Where links to a pdf are provided, the
# pdf files are downloaded. In some cases, no pdf link is given but a link to an appropriate
# page on the respective company's site is provided. In these cases, these links are stuffed
# into a csv file.

# This is LONG process, as there are over 11000 resources to view and potentially operate on. 
# It results in over 5,000 pdf downloads (26 Gb!). This took a few days and a few restarts.

require 'nokogiri'
require 'open-uri'

SOURCE_URL = "http://database.globalreporting.org/reports/view/"

def parse_url(anchor_id)   
  @doc.css("td span##{anchor_id} a").map {|l| l['href']}.first
end

def parse_pdf_url
  parse_url "c-pdf_url"
end

def parse_html_url
  parse_url "c-html_url"
end

def parse_name(css_class)
  @doc.css("h3.#{css_class}").text.strip.gsub(/\W/,"_")
end

def parse_company_name
  parse_name "company-name"
end

def parse_report_name
  parse_name "report-title"
end

def write_link(file,link)
  File.open(file,'a') { |f| f.write link + "\n" } unless link.nil?
end

def write_pdf_link(link)
  write_link("gri_pdf_reports.csv",link)
end

def write_html_link(link)
  write_link("gri_html_reports.csv",link) 
end

(1...11231).each do |i| #

  puts "index ##{i}\n"
  url = SOURCE_URL + i.to_s

  begin
    @doc = Nokogiri::HTML(open(url))
    company = parse_company_name
    report  = parse_report_name

    # If a pdf link exists, download it
    if pdf_link = parse_pdf_url
      url = URI.parse(pdf_link)
      route = url.route_from("#{url.scheme}://#{url.host}").to_s

      
      request = Net::HTTP::Get.new(route)
      response = Net::HTTP.start(url.host, url.port) do |http|
        http.read_timeout = 5000
        http.open_timeout = 5000

        http.request(request)
      end

      # Record pdf link in csv file
      write_pdf_link(pdf_link)
    

      
      filename = "#{company}_#{report}.pdf"
      puts "saved #{filename}"
      File.open(filename, 'w') { |file| file.write response.body }
    end

    # If an html link exists, record it in csv file
    if html_link = parse_html_url
      write_html_link(html_link)
      puts "recorded #{html_link}"
    end

  rescue
    puts "!!! failed #{url}" 
    next
  end

  puts "\n\n"

  # Wait before next request as a courtesy
  sleep 5

end