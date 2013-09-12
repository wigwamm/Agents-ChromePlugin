class Filter
  include Mongoid::Document

  @@include_markers_for_options = {
      'Agents and Listings' => 0,
      'Listings' => 1,
      'Agents' => 2
  }

  field :name
  field :areas, type: Array, default: []
  field :agents, type: Array, default: []
  field :include_markers_for, type: Integer, default: 0
  field :min_price, type: Integer
  field :max_price, type: Integer
  field :min_bedrooms, type: Integer
  field :max_bedrooms, type: Integer
  field :type
  field :polygon, type: Array, default: []
  field :edited, type: Boolean, default: false

  def self.include_markers_for_options
    @@include_markers_for_options
  end
end
