class Agent
  include Mongoid::Document
  field :name
  #field :branches, type: Array, default: []
  field :address
  field :area
  field :location, type: Array
  field :rightmove_id

  has_many :listings
end
