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
  field :agent
  field :address
  field :number
  field :location, type: Array, default: []
  field :is_duplicate, type: Boolean

  reverse_geocoded_by :location
  belongs_to :agent

  def url
    "http://www.rightmove.co.uk/property-to-rent/property-#{self.property_ids[0].gsub(/\D/,'')}.html"
  end
end
