class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true

  validates :city, :state, :street, :zip, presence: true

  geocoded_by :full_street_address
  after_validation :geocode, if: :changed?

  def full_street_address
    [street, city, state].compact.join(', ')
  end

  def city_state
    [city, state].join(', ')
  end
end
