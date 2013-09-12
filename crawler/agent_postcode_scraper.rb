require './postcode_crawler'
require 'mechanize'

class AgentPostcodeScraper < PostcodeScraper

  def initialize
    super('agent_list')

    @allowed_postcodes_regex = /^(SW|SE|W|NW|WC|N|E|EC)\d+[A-Z]?$/
    #@allowed_postcodes_regex = /^(SW3)$/
    @items_per_page = 20
  end

  def fill_form(mechanize, postcode)
    mechanize.get('http://www.rightmove.co.uk/estate-agents.html') do |page|
      search_result = page.form_with(id: 'branchSearchCriteria') do |search|
        search.searchLocation = postcode
      end.submit

      scrape_pages(search_result, Nokogiri::HTML(search_result.body))
    end
  end

  def scrape(url, document)
    document.css('h2.branchname a').each do |link|
      puts "http://www.rightmove.co.uk#{link['href']}"
      @channel.default_exchange.publish("http://www.rightmove.co.uk#{link['href']}", routing_key: @queue.name)
    end
  end

end

scraper = AgentPostcodeScraper.new
scraper.run
while true
  sleep(1)
end