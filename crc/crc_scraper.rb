#!/bin/env ruby
# encoding: utf-8

# This script downloads and parses and cleans the XML formatted version of the 2010-2011 disclosures to the UK's
# mandatory greenhouse gas emissions reporting scheme, the Carbon reduction Commitment. 
#
# The result is a CSV file containing a few of the most significant data fields for each company.

require 'rexml/document'
require 'net/http'
require 'cgi'

class String
  def quote
    return "\"#{self}\""
  end

  def sub_ampersands
    return self.gsub("&", "_AMPERSAND_")
  end

  def encode_path
    return self.gsub(/[\s\/]/, "_")
  end

  def sub_double_quotes
    return self.gsub('"',"'")
  end

  def clean_up
    return self.gsub("â","'").sub_double_quotes
  end

end

include REXML

def create_csv_data(doc_root)
  table   = []
  headers = %w( organizationName registrationNumber emissions rank tradingName weightedScore earlyActionMetric absoluteMetric growthMetric source)
  table << headers.map { |header| header.quote }

  # Build data table
  doc_root.elements.each do |scorecard|

    hash = {}
    hash['organizationName']   = scorecard.elements['participantState/registrantName'].text.clean_up
    hash['registrationNumber'] = scorecard.elements['participantState/registrantNumber'].text
    hash['emissions']          = scorecard.elements['participantState/crcEmissions'].text
    hash['rank']               = scorecard.elements['overallRank'].text

    if trading_name = scorecard.elements['participantState/groupStructureState/roots/SGUDetails/partyDetails/tradingName']
      hash['tradingName'] = trading_name.text.clean_up
    else
      hash['tradingName'] = nil
    end

    hash['weightedScore']     = scorecard.elements['overallScore'].text
    hash['earlyActionMetric'] = scorecard.elements['earlyActionAchievementDetails/earlyActionAchievementResult'].text
    hash['absoluteMetric']    = scorecard.elements['absoluteEmissionsAchievementDetails/absoluteAchievementResult'].text
    hash['growthMetric']      = scorecard.elements['growthScore'].text
    hash['source']            = url
    
    table << headers.map do |header| 
      value = hash[header]
      value.nil? ? value : value.sub_ampersands.quote
    end

  end

  # Write table to csv
  File.open("data.csv","w") do |file|
    table.each do |row|
      file.write row.join(",") + "\n"
    end
  end

end

url = "http://crc.environment-agency.gov.uk/pplt/web/plt/public/2010-11/CRCPerformanceLeagueTable20102011/download"
xml = Net::HTTP.get_response(URI.parse(url))
doc = REXML::Document.new(xml.body)
root = doc.elements["LeagueTablePublication/participantScorecards"]

create_csv_data(root)