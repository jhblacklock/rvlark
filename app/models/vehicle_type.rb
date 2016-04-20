class VehicleType < ActiveRecord::Base
  extend FriendlyId

  friendly_id :name, use: :slugged
  has_many :photos, dependent: :destroy, as: :photoable

  def main_photo
    photos.first
  end
end
