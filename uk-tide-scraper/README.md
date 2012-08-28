UK Tide Predictions Scraper
===========================

Simple web scraper for retrieving UK tide predictions. 

Author: Andrew Berkeley (andrew.berkeley.is@googlemail.com)

About
=====
The data is taken from the UK's National Oceanography Centre, which provides tide prediction for the next 28 days for over 50 UK sites.

Currently the script only scrapes the page for Millport, returning the date, time and elevation of tidal maxima and minima.

ScraperWiki
===========
A version of this scraper (see uk_tide_scraper_wiki.rb) resides at scaperwiki.com (https://scraperwiki.com/scrapers/millport_uk_tide_table/) where it runs daily and stores an archive of past tide data. 

To do
=====
* Add support for additional sites
* Add Ordnance Datum conversion

License
=======

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program (see the COPYING file).  If not, see
<http://www.gnu.org/licenses/>.
