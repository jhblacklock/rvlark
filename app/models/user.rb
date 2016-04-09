class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable
  validates :first_name, length: { maximum: 50 }, presence: true
  validates :last_name, length: { maximum: 50 }, presence: true

  has_many :vehicles, dependent: :destroy
  has_many :reservations, dependent: :destroy
  has_many :trips, class_name: 'Booking', foreign_key: 'owner_id'
  has_many :bookings, dependent: :destroy

  has_attached_file :avatar, styles: { medium: '300x300#', thumb: '100x100#' },
                             default_url: '/user-missing.png'
  validates_attachment_content_type :avatar, content_type: %r{\Aimage\/.*\Z}

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    return user if user

    create_user
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def create_user
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.image = auth.info.image
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def member_since
    created_at.to_date.to_s(:long_ordinal)
  end
end
