class CreateVehicleTypes < ActiveRecord::Migration
  def change
    create_table :vehicle_types do |t|
      t.string :name
      t.text :description
      t.string :slug
      t.string :tagline

      t.timestamps null: false
    end
    add_index :vehicle_types, :slug, unique: true
  end
end
