class CreateAmenities < ActiveRecord::Migration
  def change
    create_table :amenities do |t|
      t.string :amenity_type
      t.boolean :active, default: true
      t.string :name
      t.string :description
      t.boolean :extended_int, default: true

      t.timestamps null: false
    end

    create_table :amenities_vehicles, id: false do |t|
      t.belongs_to :amenity, index: true
      t.belongs_to :vehicle, index: true
    end
  end
end
