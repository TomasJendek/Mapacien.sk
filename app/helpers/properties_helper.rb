module PropertiesHelper

  def self.translate_property_type
    [[ I18n.t(:sell), "sell"], [I18n.t(:rent), "rent"]]
  end

  def self.translate_rooms
    [[ "Garzonka", "studio"], [I18n.t(:room_1), "one"], [I18n.t(:room_2), "two"], [I18n.t(:room_3), "three"], [I18n.t(:room_4), "four"]]
  end

  def self.translate_state_type
    [[I18n.t(:state_1), "new_building"], [I18n.t(:state_2), "original"] , [I18n.t(:state_3), "reconstruction"]]
  end

  def self.translate_categories
    [["byt", "flat"], ["dom", "house"]]
  end

end
