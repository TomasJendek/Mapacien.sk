class Property < ActiveRecord::Base
  #attr_accessor :property_category, :property_type, :num_of_room, :state_type

  as_enum :property_category, [:flat, :house]
  as_enum :property_type, [:sell, :rent]
  as_enum :num_of_room, [:studio, :one, :two, :three, :four, :five, :six, :seven, :more]
  as_enum :state_type, [:new_building, :original, :reconstruction]


  as_enum :country, [:sk, :cz]

  def self.country(country)
    result = where(:country_cd => 0) if country == "sk"
    result = where(:country_cd => 1) if country == "cz"

    return result
  end

  def self.boundaries(sw_lat, ne_lat, sw_lon, ne_lon)
    where(latitude: sw_lat..ne_lat, longitude: sw_lon..ne_lon)
  end

  def self.category(category)
    where(property_category_cd: [Property.property_categories[category.to_sym]])
  end

  def self.type(type)
    where(property_type_cd: [Property.property_types[type.to_sym]])
  end

  def self.state_type(state_type)
    where(state_type_cd: [Property.state_types[state_type.to_sym]])
  end

  def self.num_of_room(num_of_rooms)
    where(num_of_room_cd: [Property.num_of_rooms[num_of_rooms.to_sym]])
  end


end
