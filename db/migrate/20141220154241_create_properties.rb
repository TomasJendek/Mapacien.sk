class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.integer :floor
      t.integer :total_floors
      t.integer :area
      t.integer :price
      t.integer :price_m2
      t.text    :original_url
      t.integer :num_of_room_cd
      t.integer :property_type_cd
      t.integer :state_type_cd
      t.integer :property_category_cd
      t.integer :country_cd
      t.decimal :latitude, :precision => 10, :scale => 7
      t.decimal :longitude, :precision => 10, :scale => 7
      t.timestamps
    end
  end
end
