class AddAttachmentAvatarToUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :image
    change_table :users do |t|
      t.attachment :avatar
    end
  end

  def self.down
    add_column :users, :image, :string
    remove_attachment :users, :avatar
  end
end
