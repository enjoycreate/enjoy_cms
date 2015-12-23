module Enjoy
  module Models
    module Mongoid
      module GalleryImage
        extend ActiveSupport::Concern
        include Enjoy::MongoidPaperclip

        included do

          acts_as_nested_set
          scope :sorted, -> { order_by([:lft, :asc]) }

          enjoy_mongoid_attached_file(:image,
                    styles: image_styles,
                    content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }
          )
        end
      end
    end
  end
end
