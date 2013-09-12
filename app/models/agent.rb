class Agent
  include Mongoid::Document
  field :name
  #field :branches, type: Array, default: []
  field :address
  field :area
  field :location, type: Array
  field :rightmove_id

  field :url

  has_many :listings
end
