class Photo < ActiveRecord::Base
  belongs_to :photoable, polymorphic: true

  has_attached_file :image, styles: { medium: '360x270#', thumb: '100x75#', square: '100x100#' }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
end
