class AddTaglineToDestinations < ActiveRecord::Migration
  def change
    add_column :destinations, :tagline, :string
  end
end
