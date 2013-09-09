require './scraper'
require './area_finder'

class AgentScraper < Scraper

  def initialize
    super('agent_list')

    @area_finder = AreaFinder.new
  end

  def scrape(url, document)
    name = document.css('#pageheader h1').first.content.strip
    address = document.css('.address').first.content.strip
    id = url.gsub(/\D+/, '')

    location_lookup = Geocoder.search(address)
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
#scraper.debug = true
#scraper.run
scraper.scrape_url('http://www.rightmove.co.uk/estate-agents/agent/Andrews-Estate-Agents/Streatham-6475.html')
