class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.date :check_in
      t.date :check_out
      t.float :total_amount
      t.float :rental_amount
      t.float :service_fee
      t.string :state, default: 'pending'
      t.integer :user_id
      t.integer :owner_id
      t.integer :vehicle_id

      t.timestamps null: false
    end
  end
end
