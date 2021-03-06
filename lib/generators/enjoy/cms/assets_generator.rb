require 'rails/generators'

module Enjoy::Cms
  class AssetsGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates/assets', __FILE__)

    desc 'Enjoy CMS assets generator'
    def install
      assets_files.each do |f|
        template "#{f}.erb", "app/assets/#{f}"
      end
    end


    def rails_admin_theming_sass_path
      "stylesheets/enjoy/rails_admin/custom/ui.sass"
    end

    def application_sass_path
      "stylesheets/application.sass"
    end

    def application_coffee_path
      "javascripts/application.coffee"
    end

    def assets_files
      [
        rails_admin_theming_sass_path,
        application_sass_path,
        application_coffee_path
      ]
    end
  end
end
