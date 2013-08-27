class Listing
  include Mongoid::Document
  include Mongoid::Timestamps
  field :ids, type: Array, default: []
  field :urls, type: Array, default: []
  field :address, type: String
end
