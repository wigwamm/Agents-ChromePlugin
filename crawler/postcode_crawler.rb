require './scraper'
require 'mechanize'

class PostcodeScraper < Scraper

  def initialize(queue_name='links')
    super(queue_name)

    #@allowed_postcodes_regex = /^(SW|SE|W|NW|WC|N|E|EC)\d+[A-Z]?$/
    @allowed_postcodes_regex = /^(SW)\d+[A-Z]?$/
    @districts = []
    @items_per_page = 10

  end

  def scan_postcodes
    File.open('postcodes.csv', 'r').each_line do |line|
      district = line[0..(line.index(',') - 1)]

      if district =~ @allowed_postcodes_regex
        @districts.push district
      end
    end
  end

  def run
    scan_postcodes

    @districts.each do |postcode|

      a = Mechanize.new { |agent|
        agent.user_agent_alias = 'Mac Safari'
      }

      fill_form(a, postcode)

    end
  end

  def fill_form(mechanize, postcode)
    mechanize.get('http://www.rightmove.co.uk/property-to-rent.html') do |page|
      search_result = page.form_with(id: 'initialSearch') do |search|
        search.searchLocation = postcode
      end.submit

      submit_form(search_result.form_with(id: 'propertySearchCriteria'))

    end
  end

  def submit_form(search_form)
    if search_form
      submit_result = search_form.submit
      scrape_pages(submit_result, Nokogiri::HTML(submit_result.body, nil, 'iso-8859-1'))
    else
      puts 'Invalid page'
    end
  end

  def scrape_pages(page, doc)
    page_count_element = doc.css('.pagenavigation.pagecount').first


    if page_count_element
      page_count = Integer(doc.css('.pagenavigation.pagecount').first.content.split[3])
    else
      page_count = 1
    end

    values = CGI::parse(page.uri.query)

    urls = []
    (0...page_count).each do |i|
      values['index'] = i * @items_per_page
      page.uri.query = URI.encode_www_form(values)

      urls.push page.uri.to_s
    end

    urls.each do |url|
      @pool.schedule do
        begin
          #puts "Scraping #{url}"
          scrape(url, Nokogiri::HTML(open(url)))
        rescue e
          puts 'Exception'
          puts e
        end
      end
    end
  end

  def scrape(url, document)
    document.css('h2.address.bedrooms a').each do |link|
      puts "http://www.rightmove.co.uk#{link['href']}"
      @channel.default_exchange.publish("http://www.rightmove.co.uk#{link['href']}", routing_key: @queue.name)
    end
  end

end

if __FILE__ == $0
  scraper = PostcodeScraper.new
  scraper.run

  while true
    sleep(1)
  end
end