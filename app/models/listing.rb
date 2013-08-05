class Listing
  include Mongoid::Document
  include Mongoid::Timestamps
  field :urls, type: Array, default: []
  field :address, type: String
end
