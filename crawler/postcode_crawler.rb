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

File.open('postcodes.csv', 'r').each_line do |line|
  postcode_area = line[0..2]

  if postcode_area == 'SW2'
    districts.push line[0..(line.index(',') - 1)]
  end

end

pool = Pool.new(10)

districts.each do |postcode|
  pool.schedule {
    a = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }

    a.get('http://www.rightmove.co.uk/property-to-rent.html') do |page|
      search_result = page.form_with(id: 'initialSearch') do |search|
        search.searchLocation = postcode
      end.submit

      listings = search_result.form_with(id: 'propertySearchCriteria').submit

      doc = Nokogiri::HTML(listings.body)
      page_count_element = doc.css('.pagenavigation.pagecount').first


      if page_count_element
        page_count = Integer(doc.css('.pagenavigation.pagecount').first.content.split[3])
      else
        page_count = 1
      end

      values = CGI::parse(listings.uri.query)

      urls = []
      (0...page_count).each do |i|
        values['index'] = i * 10
        listings.uri.query = URI.encode_www_form(values)

        urls.push listings.uri.to_s
      end



      urls.each do |url|
        pool.schedule do

          listings_doc = Nokogiri::HTML(open(url))
          #url_counter += 1
          #puts "#{url_counter}"
          listings_doc.css('h2.address.bedrooms a').each do |link|
            puts "http://www.rightmove.co.uk#{link['href']}"
            channel.default_exchange.publish("http://www.rightmove.co.uk#{link['href']}", routing_key: queue.name)
          end
        end
      end

    end
  }
end

sleep(1) until pool.is_done?

# - Finally, register an `at_exit`-hook that will wait for our thread pool
#   to properly shut down before allowing our script to completely exit.
at_exit {
  pool.shutdown
  connection.close
}

puts Time.now