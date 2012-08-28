UK Grid Output
==============

Feed parser for UK grid production data.

Author: Andrew Berkeley (andrew.berkeley.is@googlemail.com)

About
=====
Retrieves the total daily energy production (MWh) and split by production type (%) of the UK electricity grid.

Data fields are as follows:

* DATE – Date of record
* TOTAL – All power (MWh)
* COAL – Coal-based power production (%)
* OIL – Oil (%)
* CCGT – Combined-cycle gas turbine (%)
* OCGT – Open cycle gas turbine (%)
* NUCLEAR – Nuclear (%)
* PS – Pumped storage (%)
* NPSHYD – Non-pumped storage hydro (%)
* INTFR – Interconnector, France (%)
* INTIRL – Interconnector, Irish (Moyle) (%)
* INTEW – Interconnector, East-West (Irish) (%)
* INTNED – Interconnector, Netherlands (%)

Data is available from the same feed at 5 minute and half-hourly resolution.

ScraperWiki
===========
A version of this scraper (see uk_grid_output_scraper_wiki.rb) resides at scaperwiki.com (https://scraperwiki.com/scrapers/uk_grid_output_by_production_type/) where it runs daily and stores an archive of past output data. 

To do
=====
* Add support for higher resolutions feeds. These are only small changes to the XML paths and attributes.

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
