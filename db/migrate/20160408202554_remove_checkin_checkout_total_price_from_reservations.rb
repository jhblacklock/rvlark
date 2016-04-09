class RemoveCheckinCheckoutTotalPriceFromReservations < ActiveRecord::Migration
  def change
    remove_column :reservations, :check_in, :date
    remove_column :reservations, :check_out, :date
    remove_column :reservations, :total, :integer
    remove_column :reservations, :price, :integer
    add_column :reservations, :booking_id, :integer
  end
end
