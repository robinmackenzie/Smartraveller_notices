require 'scraperwiki'
require 'mechanize'

def do_scrape
	# set reference to mechanize
	agent = Mechanize.new

	# set variables for smartraveller.com.au country notices
	base_url = "http://smartraveller.gov.au/countries/"
	countries = get_countries
	today = Time.now.strftime("%Y-%m-%d")
	notice_prefix = "Official advice: "

	# countries with a notice will have a div with a notice class
	# countries without a notice will not
	hook = "div.notice"

	# iterate country list
	countries.each do |country|
		country_url = base_url + country
		page = agent.get(country_url)
		target_div = page.at(hook)

		if not target_div == nil
			notice = target_div.text.gsub(/\s+/, " ").strip
			notice = notice.gsub! notice_prefix, ""
		else
			notice = "Nil"
		end

	    record = {
	      date: today,
	      country: country,
	      notice: notice
	    }

	    p record
	 
	end

end

# # Write out to the sqlite database using scraperwiki library
# ScraperWiki.save_sqlite(["name"], {"name" => "susan", "occupation" => "software developer"})
#
# # An arbitrary query against the database
# ScraperWiki.select("* from data where 'name'='peter'")

def get_countries
	return [
		"Afghanistan", 
		"Albania", 
		"Algeria", 
		"American_Samoa", 
		"Andorra", 
		"Angola", 
		"Antigua_and_Barbuda", 
		"Argentina", 
		"Armenia", 
		"Aruba", 
		"Austria", 
		"Azerbaijan", 
		"Bahamas", 
		"Bahrain", 
		"Bangladesh", 
		"Barbados", 
		"Belarus", 
		"Belgium", 
		"Belize", 
		"Benin", 
		"Bhutan", 
		"Bolivia", 
		"Bosnia_and_Herzegovina", 
		"Botswana", 
		"Brazil", 
		"Brunei_Darussalam", 
		"Bulgaria", 
		"Burkina_Faso", 
		"Burma", 
		"Burundi", 
		"Cabo_Verde", 
		"Cambodia", 
		"Cameroon", 
		"Canada", 
		"Central_African_Republic", 
		"Chad", 
		"Chile", 
		"China", 
		"Colombia", 
		"Comoros", 
		"Cook_Islands", 
		"Costa_Rica", 
		"Croatia", 
		"Cuba", 
		"Cyprus", 
		"Czech_Republic", 
		"Ivory_Coast", 
		"North_Korea", 
		"Democratic_Republic_of_the_Congo", 
		"Denmark", 
		"Djibouti", 
		"Dominica", 
		"Dominican_Republic", 
		"Ecuador", 
		"Egypt", 
		"El_Salvador", 
		"Equatorial_Guinea", 
		"Eritrea", 
		"Estonia", 
		"Ethiopia", 
		"Federated_States_of_Micronesia", 
		"Fiji", 
		"Finland", 
		"Former_Yugoslav_Republic_of_Macedonia", 
		"France", 
		"French_Polynesia", 
		"Gabon", 
		"Gambia", 
		"Georgia", 
		"Germany", 
		"Ghana", 
		"Gibraltar", 
		"Greece", 
		"Greenland", 
		"Grenada", 
		"Guam", 
		"Guatemala", 
		"Guinea", 
		"Guinea-Bissau", 
		"Guyana", 
		"Haiti", 
		"Honduras", 
		"Hong_Kong", 
		"Hungary", 
		"Iceland", 
		"India", 
		"Indonesia", 
		"Iran", 
		"Iraq", 
		"Ireland", 
		"Israel_Gaza_Strip_and_West_Bank", 
		"Italy", 
		"Jamaica", 
		"Japan", 
		"Jordan", 
		"Kazakhstan", 
		"Kenya", 
		"Kiribati", 
		"Kosovo", 
		"Kuwait", 
		"Kyrgyz_Republic", 
		"Laos", 
		"Latvia", 
		"Lebanon", 
		"Lesotho", 
		"Liberia", 
		"Libya", 
		"Liechtenstein", 
		"Lithuania", 
		"Luxembourg", 
		"Macau", 
		"Madagascar", 
		"Malawi", 
		"Malaysia", 
		"Maldives", 
		"Mali", 
		"Malta", 
		"Marshall_Islands", 
		"Mauritania", 
		"Mauritius", 
		"Mexico", 
		"Moldova", 
		"Monaco", 
		"Mongolia", 
		"Montenegro", 
		"Morocco", 
		"Mozambique", 
		"Namibia", 
		"Nauru", 
		"Nepal", 
		"Netherlands", 
		"Netherlands_Antilles", 
		"New_Caledonia", 
		"New_Zealand", 
		"Nicaragua", 
		"Niger", 
		"Nigeria", 
		"Niue", 
		"Northern_Mariana_Islands", 
		"Norway", 
		"Oman", 
		"Pakistan", 
		"Palau", 
		"Panama", 
		"Papua_New_Guinea", 
		"Paraguay", 
		"Peru", 
		"Philippines", 
		"Poland", 
		"Portugal", 
		"Puerto_Rico", 
		"Qatar", 
		"South_Korea", 
		"Congo", 
		"Reunion", 
		"Romania", 
		"Russia", 
		"Rwanda", 
		"Saint_Kitts_and_Nevis", 
		"Saint_Lucia", 
		"Saint_Vincent_and_the_Grenadines", 
		"Samoa", 
		"San_Marino", 
		"Sao_Tome_and_Principe", 
		"Saudi_Arabia", 
		"Senegal", 
		"Serbia", 
		"Seychelles", 
		"Sierra_Leone", 
		"Singapore", 
		"Slovakia", 
		"Slovenia", 
		"Solomon_Islands", 
		"Somalia", 
		"South_Africa", 
		"South_Sudan", 
		"Spain", 
		"Sri_Lanka", 
		"Sudan", 
		"Suriname", 
		"Swaziland", 
		"Sweden", 
		"Switzerland", 
		"Syria", 
		"Taiwan", 
		"Tajikistan", 
		"Tanzania", 
		"Thailand", 
		"Timor_Leste", 
		"Togo", 
		"Tonga", 
		"Trinidad_and_Tobago", 
		"Tunisia", 
		"Turkey", 
		"Turkmenistan", 
		"Tuvalu", 
		"Uganda", 
		"Ukraine", 
		"United_Arab_Emirates", 
		"United_Kingdom", 
		"United_States_of_America", 
		"Uruguay", 
		"Uzbekistan", 
		"Vanuatu", 
		"Venezuela", 
		"Vietnam", 
		"Wallis_and_Futuna", 
		"Yemen", 
		"Zambia", 
		"Zimbabwe" 
	]
end

# call main method
do_scrape
