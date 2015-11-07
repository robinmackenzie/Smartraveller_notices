require 'scraperwiki'
require 'mechanize'

def do_scrape
	# set reference to mechanize
	agent = Mechanize.new

	# counters/ timer
	start_time = Time.now
	country_count = 0
	region_count = 0

	# set variables for smartraveller.com.au country notices
	base_url = "http://smartraveller.gov.au"
	continent_region_items = get_continent_regions
	today = Time.now.strftime("%Y-%m-%d")

	# region pages have an unordered list of countries
	country_list_hook = "ul.list_statuses"

	# country pages with a notice will have a div with a notice class
	# country pages without a notice will not
	notice_hook = "div.notice"

	# iterate continent region list
	continent_region_items.each do |item|
		# increment region counter
		region_count += 1

		# columns 0, 1 and 2 are continent, region and url
		continent = item[0]
		region = item[1]
		region_url = item[2]

		# get a page of region countries
		region_page = agent.get(base_url + region_url)

		# get list of countries
		target_list = region_page.at(country_list_hook)
		if not target_list == nil

			# iterate list items and check each country page
			target_list.search("li").each do |country_hook|
				# increment country counter
				country_count += 1

				# get country info
				country_name = country_hook.at("a").inner_text.strip
				# count spans in list item - should be 3
				country_span_count = country_hook.search("span").count

				if country_span_count >= 2
					country_notice_short = country_hook.search("span")[2].inner_text.strip
					# parse notice if div is present
					if not country_notice_short == ""
						level = get_notice_level(country_notice_short)
					else
						# no notice for this country
						country_notice_short = "None"
						level = 0
					end

					# construct record for this country, on this date
			    	record = {
			      		date: today,
			      		continent: continent,
			      		region: region,
			      		country: country_name,
			      		notice: country_notice_short,
			      		level: level
			    		}

				    # update database
				    ScraperWiki.save_sqlite([:date, :country], record)
				end
			end
		end
	end

	# output to console
	finish_time = Time.now
	puts "Start time: " + start_time.strftime("%Y-%m-%d %H:%M:%S")
	puts "Regions analysed: " + region_count.to_s
	puts "Countries analysed: " + country_count.to_s
	puts "Finish time: " + finish_time.strftime("%Y-%m-%d %H:%M:%S")
	puts "Elapsed time (s): " + (finish_time - start_time).to_s
end

def get_notice_level(notice)
	if notice.downcase.include? "normal"
		return 1
	elsif notice.downcase.include? "caution"
		return 2
	elsif notice.downcase.include? "reconsider"
		return 3
	elsif notice.downcase.include? "do not travel"
		return 4
	else
		return -1
	end
end

def get_continent_regions
	return [
			["Americas", "Caribbean", "/countries/americas/caribbean/"],
			["Americas", "Central America", "/countries/americas/central/"],
			["Americas", "North America", "/countries/americas/north/"],
			["Americas", "South America", "/countries/americas/south/"],
			["Africa", "Central Africa", "/countries/africa/central/"],
			["Africa", "East Africa", "/countries/africa/east/"],
			["Africa", "North Africa", "/countries/africa/north/"],
			["Africa", "Southern Africa", "/countries/africa/southern/"],
			["Africa", "West Africa", "/countries/africa/west/"],
			["Asia", "Central Asia", "/countries/asia/central/"],
			["Asia", "North Asia", "/countries/asia/north/"],
			["Asia", "South Asia", "/countries/asia/south/"],
			["Asia", "South East Asia", "/countries/asia/south-east/"],
			["Europe", "Eastern Europe", "/countries/europe/eastern/"],
			["Europe", "Northern Europe", "/countries/europe/northern/"],
			["Europe", "Southern Europe", "/countries/europe/southern"],
			["Europe", "Western Europe", "/countries/europe/western/"],
			["RoW", "Middle east", "/countries/middle-east/"],
			["RoW", "Pacific", "/countries/pacific/"]
		]

end

# call main method
do_scrape
