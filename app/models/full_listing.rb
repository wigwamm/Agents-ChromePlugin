require 'geocoder'

class FullListing
  include Mongoid::Document
  include Geocoder::Model::Mongoid
  field :property_id

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
    "http://www.rightmove.co.uk/property-to-rent/property-#{self.property_id}.html"
  end
end