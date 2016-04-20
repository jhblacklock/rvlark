class ChangePhotosToPolymorphic < ActiveRecord::Migration
  def up
    remove_foreign_key "photos", "vehicles"
    rename_column :photos, :vehicle_id, :photoable_id
    add_column :photos, :photoable_type, :string
    Photo.reset_column_information
    Photo.update_all(photoable_type: 'Vehicle')
    remove_index "photos", "photoable_id"
    add_index "photos", ["photoable_type", "photoable_id"]
  end

  def down
    rename_column :photos, :photoable_id, :vehicle_id
    remove_column :photos, :photoable_type
    add_index "photos", "vehicle_id"
    remove_index "photos", ["photoable_type", "photoable_id"]
    add_foreign_key "photos", "vehicles"
  end
end
