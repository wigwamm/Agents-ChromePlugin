class Average
  include Mongoid::Document
  include Mongoid::Timestamps

  field :averages, type: Array, default: []
  field :medians, type: Array, default: []
  field :counts, type: Array, default: [0, 0, 0, 0, 0, 0, 0, 0, 0]

  embedded_in :area
end
