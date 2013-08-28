class Listing
  include Mongoid::Document
  include Mongoid::Timestamps
  field :ids, type: Array, default: []

  field :marked_unavailable_by, type: Array, default:[]
  field :marked_available_by, type: Array, default:[]
  field :is_available, type: Boolean, default: false

  field :availability_score, type: Integer, default: 0

  field :urls, type: Array, default: []
  field :address, type: String
end
