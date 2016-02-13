class AddListingNameToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :listing_name, :string
  end
end
