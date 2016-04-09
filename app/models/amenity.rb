class Amenity < ActiveRecord::Base
  has_and_belongs_to_many :vehicles

  validates :name, uniqueness: true, presence: true

  scope :safety, -> { where(amenity_type: 'Safety') }
  scope :tech, -> { where(amenity_type: 'Tech') }
  scope :kitchen, -> { where(amenity_type: 'Kitchen') }
  scope :utilities, -> { where(amenity_type: 'Utilities') }
  scope :extras, -> { where(amenity_type: 'Extras') }
  scope :features, -> { where(amenity_type: 'Features') }
end
