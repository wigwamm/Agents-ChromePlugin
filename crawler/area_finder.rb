require 'nokogiri'

class Point
  def initialize(lng, lat)
    @x = lng
    @y = lat
  end

  attr_reader :x, :y
end

class Area
  def initialize(points)
    @points = points
  end

  def [](i)
    @points[i]
  end

  def size
    @points.size
  end

  def contains_point?(point)
    contains_point = false
    i = -1
    j = self.size - 1
    while (i += 1) < self.size
      a_point_on_polygon = self[i]
      trailing_point_on_polygon = self[j]
      if point_is_between_the_ys_of_the_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
        if ray_crosses_through_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
          contains_point = !contains_point
        end
      end
      j = i
    end
    return contains_point
  end

  private

  def point_is_between_the_ys_of_the_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
    (a_point_on_polygon.y <= point.y && point.y < trailing_point_on_polygon.y) ||
        (trailing_point_on_polygon.y <= point.y && point.y < a_point_on_polygon.y)
  end

  def ray_crosses_through_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
    (point.x < (trailing_point_on_polygon.x - a_point_on_polygon.x) * (point.y - a_point_on_polygon.y) /
        (trailing_point_on_polygon.y - a_point_on_polygon.y) + a_point_on_polygon.x)
  end
end

class AreaFinder
  def initialize
    @areas = {}

    self.load_areas
  end

  def load_areas
    doc = Nokogiri::XML(File.open('areas.kml'))
    doc.css('Folder').each do |area|

      coordinates = area.css('coordinates').first.content
      name = area.css('name').first.content
      points = []

      coordinates.split(/\n/).each do |line|

        next if line.length == 0

        point_coordinates = line.strip.split(',')
        begin
          points.push Point.new(Float(point_coordinates[0]), Float(point_coordinates[1]))
        rescue TypeError
          #puts line
        end
      end

      @areas[name] = Area.new(points)

    end
  end

  def find_area(point)
    @areas.each do |name, area|
      if area.contains_point? point
        return name
      end
    end

    nil
  end
end