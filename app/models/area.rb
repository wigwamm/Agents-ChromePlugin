class Area

  @@area_array = []

  include Mongoid::Document
  field :name
  field :points, type: Array, default: []

  def self.as_array
    if @@area_array.empty?
      Area.all.each do |area|
        @@area_array.push area.name
      end
    end

    @@area_array
  end

end
