class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :addressable_type
      t.integer :addressable_id
      t.string :city
      t.string :street
      t.string :apt
      t.string :state
      t.string :zip
      t.string :address_type
      t.float :latitude
      t.float :longitude
      t.timestamps null: false
    end

    add_index 'addresses', %w(addressable_type addressable_id), name: 'index_addresses_on_addressable_type_and_addressable_id'
  end
end
