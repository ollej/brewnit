class Medium < ActiveRecord::Base
  belongs_to :parent, polymorphic: true
  has_attached_file :file,
    styles: {
      small_thumbnail: '40x40#',
      medium_thumbnail: '64x64#',
      large_thumbnail: '80x80#',
      small: '160x120#',
      medium: '320x240>',
      large: '640x480>'
    },
    convert_options: {
      all: '-strip -quality 75',
      negative: '-negate'
    }
  validates_attachment :file, presence: true,
    content_type: { content_type: %w(image/jpeg image/gif image/png) }, #/\Aimage\/.*\Z/,
    size: { in: 0..2.megabytes }
end
