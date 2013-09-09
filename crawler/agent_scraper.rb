require './scraper'
require './area_finder'

class AgentScraper < Scraper

  def initialize
    super('agent_list')

    @area_finder = AreaFinder.new
  end

  def scrape(url, document)
    encoding_options = {
        :invalid           => :replace,  # Replace invalid byte sequences
        :undef             => :replace,  # Replace anything not defined in ASCII
        :replace           => '',        # Use a blank for those replacements
        :universal_newline => true       # Always break lines with \n
    }

    name = document.css('#pageheader h1').first.content.strip
    address = document.css('.address').first.content.strip.encode(Encoding.find('ASCII'), encoding_options)
    id = url.gsub(/\D+/, '')

    sleep(1 + Random.rand(5)) unless @debug
    location_lookup = Geocoder.search(address)

    return if location_lookup.to_a.empty?

    location = location_lookup[0].coordinates

    point = Point.new(location[1], location[0])
    area = @area_finder.find_area(point)

    agent = Agent.where(rightmove_id: id).first_or_create
    agent.rightmove_id = id
    agent.name = name
    agent.address = address
    agent.location = location
    agent.area = area
    agent.save
  end

end

scraper = AgentScraper.new
scraper.debug = true
#scraper.run
scraper.scrape_url('http://www.rightmove.co.uk/estate-agents/agent/Beckley-Group/London-97328.html')
