class Medium < ActiveRecord::Base
  before_destroy :remove_references

  belongs_to :parent, polymorphic: true
  has_attached_file :file,
    styles: {
      small_thumbnail: '40x40#',
      medium_thumbnail: '64x64#',
      large_thumbnail: '80x80#',
      label: '236x236#',
      small: '160x120#',
      medium: '320x240>',
      large: '640x480>',
      label_main: '640x640#',
      label_main_wide: '775x517#',
      label_main_full: '775x1033#'
    },
    convert_options: {
      all: '-strip -quality 75',
      negative: '-negate'
    }
  validates_attachment :file, presence: true,
    content_type: { content_type: %w(image/jpeg image/gif image/png) }, #/\Aimage\/.*\Z/,
    size: { in: 0..2.megabytes }

  delegate :url, to: :file

  def remove_references
    parent.remove_media_references(self)
  end
end
