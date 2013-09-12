require 'geocoder'

class Listing
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  # Used by the plugin
  field :property_ids, type: Array, default: []

  field :marked_unavailable_by, type: Array, default:[]
  field :marked_available_by, type: Array, default:[]
  field :is_available, type: Boolean, default: false

  field :availability_score, type: Integer, default: 0

  field :urls, type: Array, default: []

  # Used by the map
  field :type
  field :description
  field :bedrooms, type: Numeric, default: 0
  field :is_shared, type: Boolean, default: false

  field :price, type: Numeric
  field :price_period
  field :pictures, type: Array, default: []
  field :agent_name
  field :agent_address
  field :address
  field :number
  field :location, type: Array, default: []
  field :is_duplicate, type: Boolean

  field :is_local_postcode_agent, type: Boolean
  field :is_local_area_agent, type: Boolean
  field :area

  reverse_geocoded_by :location
  belongs_to :agent, index: true

  def url
    "http://www.rightmove.co.uk/property-to-rent/property-#{self.property_ids[0].gsub(/\D/,'')}.html"
  end

  def check_is_agent_local
    return unless agent

    if agent.address and address

      postcode_regex = /[A-Z]{1,2}[0-9]{1,2}[A-Z]?/
      agent_postcode_match = agent.address.match(postcode_regex)
      listing_postcode_match = address.match(postcode_regex)

      if agent_postcode_match and listing_postcode_match and
          agent_postcode_match[0] == listing_postcode_match[0]

        self.is_local_postcode_agent = true
      else
        self.is_local_postcode_agent = false
      end

    else
      self.is_local_postcode_agent = false
    end

    if agent.area and area

      if agent.area == area
        self.is_local_area_agent = true
      else
        self.is_local_area_agent = false
      end
    else
      self.is_local_area_agent = false
    end

  end

end
