class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.references :vehicle, index: true, foreign_key: true
      t.integer :nightly_amount, default: 0
      t.integer :special_amount, default: 0
      t.integer :weekly_amount, default: 0
      t.integer :monthly_amount, default: 0

      t.timestamps null: false
    end
  end
end
