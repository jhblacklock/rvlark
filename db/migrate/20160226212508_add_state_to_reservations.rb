class AddStateToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :on_date, :date
    add_column :reservations, :state, :string
    remove_column :reservations, :start_date
    remove_column :reservations, :end_date
  end
end
