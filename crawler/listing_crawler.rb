require './scraper'
require './area_finder'

class ListingScraper < Scraper

  def initialize(queue_name)
    super(queue_name)
  end

  def parse_description(listing, description)
    bedrooms_regex = /((\d) bedroom|studio)/i
    type_regex = /(apartment|flat|maisonette|house|terrace house|terraced house) ?(share)?/i
    deal_regex = /(rent|sale)/i

    bedrooms = 0
    bedrooms_match = bedrooms_regex.match(description)
    if bedrooms_match and bedrooms_match[1].downcase != 'studio'
      bedrooms = Integer(bedrooms_match[2])
    end

    type = nil
    is_shared = false
    type_match = type_regex.match(description)
    if type_match

      first = type_match[1].downcase
      second = type_match[2].downcase if type_match[2]

      if first == 'apartment' || first == 'flat' || first == 'maisonette'
        type = 'flat'
      elsif first == 'house'
        type = 'house'
      elsif first == 'terrace house' || first == 'terraced house'
        type = 'terraced house'
      else
        type = 'other'
      end

      if second == 'share'
        is_shared = true
      end
    end

    listing.bedrooms = bedrooms
    listing.type = type
    listing.is_shared = is_shared

  end

  def match_local_agent(listing, agent)
    if listing.address and agent.address

      postcode_regex = /[A-Z]{1,2}[0-9]{1,2}[A-Z]?/
      agent_postcode_match = agent.address.match(postcode_regex)
      listing_postcode_match = listing.address.match(postcode_regex)

      if agent_postcode_match and listing_postcode_match and
          agent_postcode_match[0] == listing_postcode_match[0]

        listing.is_local_postcode_agent = true

      end
    end
  end

  def scrape(url, doc)
    listing = Listing.new

    doc.css('#minimapwrapper img').each do |img|
      lat_lng_match = img['src'].match(/(-?\d+\.\d+),(-?\d+\.\d+)/)
      listing.location = [Float(lat_lng_match[1]), Float(lat_lng_match[2])]

      point = Point.new(listing.location[1], listing.location[0])
      listing.area = AreaFinder.instance.find_area(point)
    end

    property_id = 'rightmove_' + url.gsub(/\D/, '')

    existing_listing = Listing.where(property_ids: property_id)
    if existing_listing.count > 0
      listing = existing_listing.first
    end

    if !listing.location.empty? and Listing.where(location: listing.location).count > 0
      listing.is_duplicate = true
    end

    address_container = doc.css('#addresscontainer h2').first
    listing.address = address_container.content.strip if address_container
    price = doc.css('#amount').first
    listing.price = Integer(price.content.gsub(/\D/,'')) if price
    frequency = doc.css('#rentalfrequency').first
    listing.price_period = frequency.content if frequency

    number = doc.css('#branchnumber span.number').first
    listing.number = number.content if number
    listing.property_ids = [property_id]

    doc.css('.thumbnailimage img').each do |img|
      listing.pictures.push img['src'][0..-17]
    end

    agent_thumbnail = doc.css('#agentdetails img').first
    agent_details = doc.css('#agentdetails a').first
    if agent_details
      agent_id = agent_details['href'].gsub(/\D/, '')
      agent = Agent.where(rightmove_id: agent_id).first_or_create

      if agent
        listing.agent = agent
        listing.check_is_agent_local
      end
    elsif agent_thumbnail
      agent_id = agent_thumbnail['src'].match(/\/(\d+)\//)[1]
      agent = Agent.where(rightmove_id: agent_id).first_or_create

      if agent
        listing.agent = agent
        listing.check_is_agent_local
      end
    end

    property_type = doc.css('#propertytype').first
    if property_type
      listing.description = property_type.content
      parse_description(listing, property_type.content)
    end

    listing.save
  end

end

if __FILE__ == $0
  scraper = ListingScraper.new('links')
  #scraper.debug = true
  scraper.run
end
