class Vehicle < ActiveRecord::Base
  belongs_to :user
  has_many :photos
  has_many :reservations
  # geocoded_by :address
  # If address is updated, geocode will generate a new set of latitude and longitude
  # after_validation :geocode, if: :address_changed?

  validates :vehicle_type, :accomodates, :listing_name, :summary, presence: true
  validates :listing_name, length: { maximum: 50 }
  validates :summary, length: { maximum: 500 }
end
