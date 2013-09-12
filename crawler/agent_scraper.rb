require './scraper'
require './area_finder'

require 'geocoder'
require File.expand_path(File.dirname(__FILE__) + '/../config/initializers/geocoder')

class AgentScraper < Scraper

  def initialize
    super('agent_list')
  end

  def scrape(url, document)
    encoding_options = {
        :invalid           => :replace,  # Replace invalid byte sequences
        :undef             => :replace,  # Replace anything not defined in ASCII
        :replace           => '',        # Use a blank for those replacements
        :universal_newline => true       # Always break lines with \n
    }

    name = document.css('#pageheader h1').first.content.strip
    address = document.css('.address').first
    if address
      address = address.content.strip.encode(Encoding.find('ASCII'), encoding_options)

      sleep(1 + Random.rand(2)) unless @debug
      location_lookup = Geocoder.search(address)

      return if location_lookup.to_a.empty?

      location = location_lookup[0].coordinates

      point = Point.new(location[1], location[0])
      area = AreaFinder.instance.find_area(point)
    end

    id = url.gsub(/\D+/, '')

    agent = Agent.where(rightmove_id: id).first_or_create
    agent.url = url
    agent.name = name
    agent.address = address if address
    agent.location = location if location
    agent.area = area if area

    agent.save
  end

end

scraper = AgentScraper.new
#scraper.debug = true
scraper.run
#scraper.scrape_url('http://www.rightmove.co.uk/estate-agents/agent/Citystyle-Living-Ltd/London-76429.html')
