class AddFieldsToVehicle < ActiveRecord::Migration
  def change
    add_column :vehicles, :latitude, :float
    add_column :vehicles, :longitude, :float
  end
end
