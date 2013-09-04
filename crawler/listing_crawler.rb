require 'bunny'

require 'open-uri'
require 'nokogiri'

require 'mongoid'

# Load the Startup model
require File.expand_path(File.dirname(__FILE__) + '/../app/models/full_listing')
require File.expand_path(File.dirname(__FILE__) + '/../app/models/agent')
Mongoid.load!('../config/mongoid.yml', :crawl)

require './thread-pool'

connection = Bunny.new
connection.start

channel = connection.create_channel
channel.prefetch(10)
queue = channel.queue('links')

pool = Pool.new(10)

crawled_counter = 0


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

puts 'Waiting for links. To exit press CTRL+C'
queue.subscribe(manual_ack: true, block: true) do |delivery_info, properties, url|

  puts "Scheduled a crawl for #{url}"

  pool.schedule {


    #puts "Trying this"
    listing_page = Nokogiri::HTML(open(url))
    #puts "didn't fail"

    listing = FullListing.new

    listing_page.css('#minimapwrapper img').each do |img|
      lat_lng_match = img['src'].match(/(-?\d+\.\d+),(-?\d+\.\d+)/)
      listing.location = [Float(lat_lng_match[1]), Float(lat_lng_match[2])]
    end

    if FullListing.where(property_id: listing_page.css('#propertytype').first.content).count == 0

      if FullListing.where(location: listing.location).count > 0
        listing.is_duplicate = true
      end

      address_container = listing_page.css('#addresscontainer h2').first
      listing.address = address_container.content.strip if address_container
      price = listing_page.css('#amount').first
      listing.price = Integer(price.content.gsub(/\D/,'')) if price
      frequency = listing_page.css('#rentalfrequency').first
      listing.price_period = frequency.content if frequency

      number = listing_page.css('#branchnumber span.number').first
      listing.number = number.content if number
      listing.property_id = url.gsub(/\D/, '')

      listing_page.css('.thumbnailimage img').each do |img|
        listing.pictures.push img['src'][0..-17]
      end

      agent_name = listing_page.css('#agentdetails a').first
      if agent_name

        agent_name_split = agent_name.content.strip.split(/ ?\, /)
        branch = agent_name_split[1]
        agent_address = listing_page.css('#branchaddress').first

        listing.agent_name = agent_name.content.strip
        listing.agent_address = agent_address.content.strip if agent_address

        agent = Agent.where(name: agent_name_split[0]).first_or_create
        agent.address = agent_address.content.strip if agent_address
        agent.branches.push branch unless agent.branches.include?(branch)

        agent.save
        listing.agent = agent
      end

      property_type = listing_page.css('#propertytype').first
      if property_type
        listing.description = property_type.content
        parse_description(listing, property_type.content)
      end

      listing.save

    end

    crawled_counter += 1
    puts crawled_counter

    channel.ack(delivery_info.delivery_tag)
    #delivery_info.consumer.cancel
  }

end

at_exit {
  pool.shutdown
  connection.close
}