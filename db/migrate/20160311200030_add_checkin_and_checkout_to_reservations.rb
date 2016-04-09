class AddCheckinAndCheckoutToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :check_in, :date
    add_column :reservations, :check_out, :date
  end
end
