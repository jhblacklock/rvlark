class Photo < ActiveRecord::Base
  belongs_to :vehicle

  has_attached_file :image, styles: { medium: '360x270#', thumb: '100x75#' }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
