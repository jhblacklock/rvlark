class Booking < ActiveRecord::Base
  has_many :reservations
  belongs_to :user
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
end
