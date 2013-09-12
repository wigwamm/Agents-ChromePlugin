#require File.expand_path(File.dirname(__FILE__) + '/../../crawler/area_finder')

module ApplicationHelper
  def link_to_add_fields(name, f, association)
    field = render "#{association.to_s}_field", f: f, value: '', association: association
    link_to(name, '#', class: 'add_fields', data: {field: field.gsub("\n", '')})
  end

  def areas
    AreaFinder.instance.areas
  end
end
