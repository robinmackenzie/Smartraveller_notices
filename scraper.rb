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
	country_info = get_country_info
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
				# get country code
				country_info_item = country_info[country_name]
				if not country_info_item == nil
					country_code = country_info[country_name][1]
				else
					country_code = "XXX"
				end

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
			      		country_code: country_code,
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

def get_country_info
	return {
		"Afghanistan" => ["Afghanistan", "AFG"],
		"Albania" => ["Albania", "ALB"],
		"Algeria" => ["Algeria", "DZA"],
		"American Samoa" => ["American_Samoa", "ASM"],
		"Andorra" => ["Andorra", "AND"],
		"Angola" => ["Angola", "AGO"],
		"Antigua and Barbuda" => ["Antigua_and_Barbuda", "ATG"],
		"Argentina" => ["Argentina", "ARG"],
		"Armenia" => ["Armenia", "ARM"],
		"Aruba" => ["Aruba", "ABW"],
		"Austria" => ["Austria", "AUT"],
		"Azerbaijan" => ["Azerbaijan", "AZE"],
		"The Bahamas" => ["Bahamas", "BHS"],
		"Bahrain" => ["Bahrain", "BHR"],
		"Bangladesh" => ["Bangladesh", "BGD"],
		"Barbados" => ["Barbados", "BRB"],
		"Belarus" => ["Belarus", "BLR"],
		"Belgium" => ["Belgium", "BEL"],
		"Belize" => ["Belize", "BLZ"],
		"Benin" => ["Benin", "BEN"],
		"Bhutan" => ["Bhutan", "BTN"],
		"Bolivia" => ["Bolivia", "BOL"],
		"Bosnia and Herzegovina" => ["Bosnia_and_Herzegovina", "BIH"],
		"Botswana" => ["Botswana", "BWA"],
		"Brazil" => ["Brazil", "BRA"],
		"Brunei Darussalam" => ["Brunei_Darussalam", "BRN"],
		"Bulgaria" => ["Bulgaria", "BGR"],
		"Burkina Faso" => ["Burkina_Faso", "BFA"],
		"Burma" => ["Burma", "MMR"],
		"Burundi" => ["Burundi", "BDI"],
		"Cabo Verde" => ["Cabo_Verde", "CPV"],
		"Cambodia" => ["Cambodia", "KHM"],
		"Cameroon" => ["Cameroon", "CMR"],
		"Canada" => ["Canada", "CAN"],
		"Central African Republic" => ["Central_African_Republic", "CAF"],
		"Chad" => ["Chad", "TCD"],
		"Chile" => ["Chile", "CHL"],
		"China" => ["China", "CHN"],
		"Colombia" => ["Colombia", "COL"],
		"Comoros" => ["Comoros", "COM"],
		"Cook Islands" => ["Cook_Islands", "COK"],
		"Costa Rica" => ["Costa_Rica", "CRI"],
		"Croatia" => ["Croatia", "HRV"],
		"Cuba" => ["Cuba", "CUB"],
		"Cyprus" => ["Cyprus", "CYP"],
		"Czech Republic" => ["Czech_Republic", "CZE"],
		"Côte d'Ivoire" => ["Ivory_Coast", "CIV"],
		"Democratic People's Republic of Korea" => ["North_Korea", "PRK"],
		"Democratic Republic of the Congo" => ["Democratic_Republic_of_the_Congo", "COD"],
		"Denmark" => ["Denmark", "DNK"],
		"Djibouti" => ["Djibouti", "DJI"],
		"Dominica" => ["Dominica", "DMA"],
		"Dominican Republic" => ["Dominican_Republic", "DOM"],
		"Ecuador" => ["Ecuador", "ECU"],
		"Egypt" => ["Egypt", "EGY"],
		"El Salvador" => ["El_Salvador", "SLV"],
		"Equatorial Guinea" => ["Equatorial_Guinea", "GNQ"],
		"Eritrea" => ["Eritrea", "ERI"],
		"Estonia" => ["Estonia", "EST"],
		"Ethiopia" => ["Ethiopia", "ETH"],
		"Federated States of Micronesia" => ["Federated_States_of_Micronesia", "FSM"],
		"Fiji" => ["Fiji", "FJI"],
		"Finland" => ["Finland", "FIN"],
		"The former Yugoslav Republic of Macedonia" => ["Former_Yugoslav_Republic_of_Macedonia", "MKD"],
		"France" => ["France", "FRA"],
		"French Polynesia" => ["French_Polynesia", "PYF"],
		"Gabon" => ["Gabon", "GAB"],
		"The Gambia" => ["Gambia", "GMB"],
		"Georgia" => ["Georgia", "GEO"],
		"Germany" => ["Germany", "DEU"],
		"Ghana" => ["Ghana", "GHA"],
		"Gibraltar" => ["Gibraltar", "GIB"],
		"Greece" => ["Greece", "GRC"],
		"Greenland" => ["Greenland", "GRL"],
		"Grenada" => ["Grenada", "GRD"],
		"Guam" => ["Guam", "GUM"],
		"Guatemala" => ["Guatemala", "GTM"],
		"Guinea" => ["Guinea", "GIN"],
		"Guinea-Bissau" => ["Guinea-Bissau", "GNB"],
		"Guyana" => ["Guyana", "GUY"],
		"Haiti" => ["Haiti", "HTI"],
		"Honduras" => ["Honduras", "HND"],
		"Hong Kong" => ["Hong_Kong", "HKG"],
		"Hungary" => ["Hungary", "HUN"],
		"Iceland" => ["Iceland", "ISL"],
		"India" => ["India", "IND"],
		"Indonesia" => ["Indonesia", "IDN"],
		"Iran" => ["Iran", "IRN"],
		"Iraq" => ["Iraq", "IRQ"],
		"Ireland" => ["Ireland", "IRL"],
		"Israel, the Gaza Strip and the West Bank" => ["Israel_Gaza_Strip_and_West_Bank", "ISR"],
		"Italy" => ["Italy", "ITA"],
		"Jamaica" => ["Jamaica", "JAM"],
		"Japan" => ["Japan", "JPN"],
		"Jordan" => ["Jordan", "JOR"],
		"Kazakhstan" => ["Kazakhstan", "KAZ"],
		"Kenya" => ["Kenya", "KEN"],
		"Kiribati" => ["Kiribati", "KIR"],
		"Kosovo" => ["Kosovo", "KOS"],
		"Kuwait" => ["Kuwait", "KWT"],
		"Kyrgyz Republic" => ["Kyrgyz_Republic", "KGZ"],
		"Laos" => ["Laos", "LAO"],
		"Latvia" => ["Latvia", "LVA"],
		"Lebanon" => ["Lebanon", "LBN"],
		"Lesotho" => ["Lesotho", "LSO"],
		"Liberia" => ["Liberia", "LBR"],
		"Libya" => ["Libya", "LBY"],
		"Liechtenstein" => ["Liechtenstein", "LIE"],
		"Lithuania" => ["Lithuania", "LTU"],
		"Luxembourg" => ["Luxembourg", "LUX"],
		"Macau" => ["Macau", "MAC"],
		"Madagascar" => ["Madagascar", "MDG"],
		"Malawi" => ["Malawi", "MWI"],
		"Malaysia" => ["Malaysia", "MYS"],
		"Maldives" => ["Maldives", "MDV"],
		"Mali" => ["Mali", "MLI"],
		"Malta" => ["Malta", "MLT"],
		"Marshall Islands" => ["Marshall_Islands", "MHL"],
		"Mauritania" => ["Mauritania", "MRT"],
		"Mauritius" => ["Mauritius", "MUS"],
		"Mexico" => ["Mexico", "MEX"],
		"Moldova" => ["Moldova", "MDA"],
		"Monaco" => ["Monaco", "MCO"],
		"Mongolia" => ["Mongolia", "MNG"],
		"Montenegro" => ["Montenegro", "MNE"],
		"Morocco" => ["Morocco", "MAR"],
		"Mozambique" => ["Mozambique", "MOZ"],
		"Namibia" => ["Namibia", "NAM"],
		"Nauru" => ["Nauru", "NRU"],
		"Nepal" => ["Nepal", "NPL"],
		"Netherlands" => ["Netherlands", "NLD"],
		"Netherlands Antilles" => ["Netherlands_Antilles", "ANT"],
		"New Caledonia" => ["New_Caledonia", "NCL"],
		"New Zealand" => ["New_Zealand", "NZL"],
		"Nicaragua" => ["Nicaragua", "NIC"],
		"Niger" => ["Niger", "NER"],
		"Nigeria" => ["Nigeria", "NGA"],
		"Niue" => ["Niue", "NIU"],
		"Northern Mariana Islands" => ["Northern_Mariana_Islands", "MNP"],
		"Norway" => ["Norway", "NOR"],
		"Oman" => ["Oman", "OMN"],
		"Pakistan" => ["Pakistan", "PAK"],
		"Palau" => ["Palau", "PLW"],
		"Panama" => ["Panama", "PAN"],
		"Papua New Guinea" => ["Papua_New_Guinea", "PNG"],
		"Paraguay" => ["Paraguay", "PRY"],
		"Peru" => ["Peru", "PER"],
		"Philippines" => ["Philippines", "PHL"],
		"Poland" => ["Poland", "POL"],
		"Portugal" => ["Portugal", "PRT"],
		"Puerto Rico" => ["Puerto_Rico", "PRI"],
		"Qatar" => ["Qatar", "QAT"],
		"Republic of Korea" => ["South_Korea", "KOR"],
		"The Republic of the Congo" => ["Congo", "COG"],
		"Reunion" => ["Reunion", "REU"],
		"Romania" => ["Romania", "ROU"],
		"Russia" => ["Russia", "RUS"],
		"Rwanda" => ["Rwanda", "RWA"],
		"Saint Kitts and Nevis" => ["Saint_Kitts_and_Nevis", "KNA"],
		"Saint Lucia" => ["Saint_Lucia", "LCA"],
		"Saint Vincent and the Grenadines" => ["Saint_Vincent_and_the_Grenadines", "VCT"],
		"Samoa" => ["Samoa", "WSM"],
		"San Marino" => ["San_Marino", "SMR"],
		"Sao Tome and Principe" => ["Sao_Tome_and_Principe", "STP"],
		"Saudi Arabia" => ["Saudi_Arabia", "SAU"],
		"Senegal" => ["Senegal", "SEN"],
		"Serbia" => ["Serbia", "SRB"],
		"Seychelles" => ["Seychelles", "SYC"],
		"Sierra Leone" => ["Sierra_Leone", "SLE"],
		"Singapore" => ["Singapore", "SGP"],
		"Slovakia" => ["Slovakia", "SVK"],
		"Slovenia" => ["Slovenia", "SVN"],
		"Solomon Islands" => ["Solomon_Islands", "SLB"],
		"Somalia" => ["Somalia", "SOM"],
		"South Africa" => ["South_Africa", "ZAF"],
		"South Sudan" => ["South_Sudan", "SDN"],
		"Spain" => ["Spain", "ESP"],
		"Sri Lanka" => ["Sri_Lanka", "LKA"],
		"Sudan" => ["Sudan", "SDN"],
		"Suriname" => ["Suriname", "SUR"],
		"Swaziland" => ["Swaziland", "SWZ"],
		"Sweden" => ["Sweden", "SWE"],
		"Switzerland" => ["Switzerland", "CHE"],
		"Syria" => ["Syria", "SYR"],
		"Taiwan" => ["Taiwan", "TWN"],
		"Tajikistan" => ["Tajikistan", "TJK"],
		"Tanzania" => ["Tanzania", "TZA"],
		"Thailand" => ["Thailand", "THA"],
		"Timor-Leste" => ["Timor_Leste", "TLS"],
		"Togo" => ["Togo", "TGO"],
		"Tonga" => ["Tonga", "TON"],
		"Trinidad and Tobago" => ["Trinidad_and_Tobago", "TTO"],
		"Tunisia" => ["Tunisia", "TUN"],
		"Turkey" => ["Turkey", "TUR"],
		"Turkmenistan" => ["Turkmenistan", "TKM"],
		"Tuvalu" => ["Tuvalu", "TUV"],
		"Uganda" => ["Uganda", "UGA"],
		"Ukraine" => ["Ukraine", "UKR"],
		"United Arab Emirates" => ["United_Arab_Emirates", "ARE"],
		"United Kingdom" => ["United_Kingdom", "GBR"],
		"United States of America" => ["United_States_of_America", "USA"],
		"Uruguay" => ["Uruguay", "URY"],
		"Uzbekistan" => ["Uzbekistan", "UZB"],
		"Vanuatu" => ["Vanuatu", "VUT"],
		"Venezuela" => ["Venezuela", "VEN"],
		"Vietnam" => ["Vietnam", "VNM"],
		"Wallis and Futuna" => ["Wallis_and_Futuna", "WLF"],
		"Yemen" => ["Yemen", "YEM"],
		"Zambia" => ["Zambia", "ZMB"],
		"Zimbabwe" => ["Zimbabwe", "ZWE"],
	}
end


# call main method
do_scrape
