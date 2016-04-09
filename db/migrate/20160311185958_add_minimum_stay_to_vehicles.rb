class AddMinimumStayToVehicles < ActiveRecord::Migration
  def change
    add_column :vehicles, :minimum_stay, :integer, default: 1
  end
end
