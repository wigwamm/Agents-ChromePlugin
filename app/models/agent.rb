class Agent
  include Mongoid::Document
  field :name, type: String
  field :branches, type: Array, default: []
  field :address, type: String

  has_many :full_listings
end
