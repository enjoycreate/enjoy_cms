require 'rails/generators'

module Enjoy::Cms
  class UnicornGodGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    argument :app_name, type: :string

    desc 'Enjoy CMS unicorn+god configs generator'
    def install
      template 'unicorn.erb',     "config/unicorn.rb"
      template 'unicorn.god.erb', "config/unicorn.god"
    end
  end
end
