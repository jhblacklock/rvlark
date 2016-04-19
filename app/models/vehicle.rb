class Vehicle < ActiveRecord::Base
  belongs_to :user
  has_many :photos, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_one :price, dependent: :destroy
  has_one :address, as: :addressable, dependent: :destroy
  has_and_belongs_to_many :amenities

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :price
  accepts_nested_attributes_for :user

  validates :vehicle_type, :accommodates, :listing_name, :summary, presence: true
  validates :listing_name, length: { maximum: 50 }
  validates :summary, length: { maximum: 500 }

  searchkick locations: %w( location )

  before_destroy { amenities.clear }

  TYPES = [['Class B Camping Van', 'b'],
           ['Class C Motor Home', 'c'],
           ['Travel Trailer', 'travel_trailer'],
           ['Fifth Wheel', 'fifth_wheel'],
           ['Folding Trailer', 'folding_trailer'],
           ['Expandable Trailer', 'expandable_trailer'],
           ['Sport Utility Trailer', 'sport_utility_trailer'],
           ['Truck Camper', 'truck_camper']].freeze

  PASSENGERS = [['1 Passenger', 1], ['2 Passengers', 2], ['3 Passengers', 3], ['4 Passengers', 4], ['5 Passengers', 5], ['6+ Passengers', 6]].freeze

  MAX_PRICES = [['100', 100], ['250', 250], ['500', 500], ['750', 750], ['1000', 1000], ['1000 +', 1001]].freeze
  MIN_PRICES = MAX_PRICES[0...-1]
  SORT = [['Low to High', 'price ASC'], ['High to Low', 'price DESC'], ['Closest First', 'location ASC'], ['Closest Last', 'location DESC']]

  delegate :latitude, :longitude, :nearbys, :city_state, to: :address, allow_nil: true
  delegate :nightly_amount, :special_amount, :weekly_amount, :monthly_amount, to: :price, allow_nil: true

  def search_data
    attributes.merge!(extended_search_hash).delete_if { |_, v| v.nil? }
  end

  def extended_search_hash
    Hash[
      location: { lat: latitude, lon: longitude }
    ]
  end

  def main_photo
    photos.first
  end

  def special_nightly_discount
    (nightly_amount * discount_percentage).to_i
  end

  def discount_percentage
    special_amount/100.to_f
  end

  def special_amount
    price.special_amount || 100
  end
end
