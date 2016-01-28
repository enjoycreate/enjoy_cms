module Enjoy
  module Models
    module Mongoid
      module News
        extend ActiveSupport::Concern
        unless Enjoy.config.news_image_styles.nil?
          include Enjoy::MongoidPaperclip
        end

        included do
          field :name, type: String, localize: Enjoy.config.localize, default: ""
          
          field :time, type: Time
          index({enabled: 1, time: 1})
          unless Enjoy.config.news_image_styles.nil?
            enjoy_cms_mongoid_attached_file(:image,
                      styles: Enjoy.configuration.news_image_styles,
                      content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }
            )
          end

          field :excerpt, type: String, localize: Enjoy.configuration.localize, default: ""
          field :content, type: String, localize: Enjoy.configuration.localize, default: ""

          scope :after_now, -> { where(:time.lt => Time.now) }
          scope :by_date, -> { desc(:time) }
        end
      end
    end
  end
end
