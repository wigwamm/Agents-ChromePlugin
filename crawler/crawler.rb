require 'nokogiri'
require 'open-uri'

# Get a Nokogiri::HTML::Document for the page we’re interested in...

doc = Nokogiri::HTML(open('http://www.rightmove.co.uk/property-to-rent/property-42955889.html'))

# Do funky things with it using Nokogiri::XML::Node methods...

####
# Search for nodes by css
type = doc.css('#propertytype').first.content
amount = doc.css('#amount').first.content
frequency = doc.css('#rentalfrequency').first.content

images = []
doc.css('.thumbnailimage img').each do |img|
  images.push img['src'][0..-17]
end

lat_lng = []
doc.css('#minimapwrapper img').each do |img|
  lat_lng_match = img['src'].match(/(-?\d+\.\d+),(-?\d+\.\d+)/)
  lat_lng = [Float(lat_lng_match[1]), Float(lat_lng_match[2])]
end


puts type
puts amount
puts frequency
images.each do |img|
  puts img
end
puts lat_lng
