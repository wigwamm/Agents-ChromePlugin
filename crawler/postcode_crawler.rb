require './scraper'

require 'bunny'
require 'nokogiri'
require 'mechanize'
require 'logger'
require 'open-uri'

require './thread-pool.rb'

puts Time.now

connection = Bunny.new
connection.start
channel = connection.create_channel
channel.prefetch(1)
queue = channel.queue('links')

districts = []

#allowed_postcodes_regex = /^(SW|SE|W|NW|WC|N|E|EC)\d+[A-Z]?$/
allowed_postcodes_regex = /^(SW)\d+[A-Z]?$/

File.open('postcodes.csv', 'r').each_line do |line|

  district = line[0..(line.index(',') - 1)]

  if district =~ allowed_postcodes_regex
    districts.push district
  end

end

pool = Pool.new(10)

districts.each do |postcode|
  #pool.schedule {
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    a.get('http://www.rightmove.co.uk/property-to-rent.html') do |page|
      search_result = page.form_with(id: 'initialSearch') do |search|
        search.searchLocation = postcode
      end.submit

      search_form = search_result.form_with(id: 'propertySearchCriteria')

      if search_form
        listings = search_form.submit
      else
        puts 'Invalid page'
        puts page
        next
      end

      doc = Nokogiri::HTML(listings.body)
      page_count_element = doc.css('.pagenavigation.pagecount').first


      if page_count_element
        page_count = Integer(doc.css('.pagenavigation.pagecount').first.content.split[3])
      else
        page_count = 1
      end

      values = CGI::parse(listings.uri.query)

      puts page_count

      urls = []
      (0...page_count).each do |i|
        values['index'] = i * 10
        listings.uri.query = URI.encode_www_form(values)

        urls.push listings.uri.to_s
      end



      urls.each do |url|
        puts 'Scheduled crawl'
        pool.schedule do

          listings_doc = Nokogiri::HTML(open(url))

          puts 'Opened page'
          listings_doc.css('h2.address.bedrooms a').each do |link|
            puts "http://www.rightmove.co.uk#{link['href']}"
            channel.default_exchange.publish("http://www.rightmove.co.uk#{link['href']}", routing_key: queue.name)
          end
        end
      end

    end
  #}
end

sleep(1) until pool.is_done?

# - Finally, register an `at_exit`-hook that will wait for our thread pool
#   to properly shut down before allowing our script to completely exit.
at_exit {
  pool.shutdown
  connection.close
}

puts Time.now

class PostcodeScraper < Scraper

end