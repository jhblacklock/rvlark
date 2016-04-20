class CreateDestinations < ActiveRecord::Migration
  def change
    create_table :destinations do |t|
      t.string :name
      t.text :description
      t.string :slug

      t.timestamps null: false
    end
    add_index :destinations, :slug, unique: true
  end
end
