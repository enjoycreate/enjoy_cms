module Enjoy
  module Admin
    module Page
      def self.config(fields = {})
        Proc.new {
          # navigation_label I18n.t('enjoy.cms')
          list do
            scopes [:sorted, :enabled, nil]

            field :enabled,  :toggle
            field :menus, :menu
            field :name
            field :fullpath do
              pretty_value do
                bindings[:view].content_tag(:a, bindings[:object].fullpath, href: bindings[:object].fullpath)
              end
            end
            field :redirect
            field :slug
          end

          edit do
            field :name
            field :excerpt, :enjoy_html
            # field :excerpt_html, :ck_editor
            # field :excerpt_clear, :toggle
            field :content, :enjoy_html
            # field :content_html, :ck_editor
            # field :content_clear, :toggle

            group :menu do
              label I18n.t('enjoy.menu')
              field :menus
              field :fullpath, :string do
                help I18n.t('enjoy.with_final_slash')
              end
              field :regexp, :string do
                help I18n.t('enjoy.page_url_regex')
              end
              field :redirect, :string do
                help I18n.t('enjoy.final_in_menu')
              end
              field :text_slug
            end
            fields.each_pair do |name, type|
              if type.nil?
                field name
              else
                if type.is_a?(Array)
                  field name, type[0], &type[1]
                else
                  field name, type
                end
              end
            end
            group :seo do
              active false
              field :seo do
                active true
              end
            end
            group :sitemap_data do
              active false
              field :sitemap_data do
                active true
              end
            end
          end

          nested_set({
            max_depth: Enjoy.config.menu_max_depth,
            scopes: []
          })

          if block_given?
            yield self
          end
        }
      end
    end
  end
end
