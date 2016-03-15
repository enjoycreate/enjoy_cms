if Enjoy.mongoid?
  module Enjoy::HashField
    extend ActiveSupport::Concern

    module ClassMethods
      def enjoy_cms_hash_field(name, opts = {})
        opts.merge!({type: Hash, default: {}})
        field "#{name}_hash", opts

        meth = name
        meth_str = "#{name}_str"
        meth_hsh = "#{name}_hash"
        meth_json = "#{name}_json"
        if opts[:localize]
          meth_str_t = "#{name}_str_translations"
          meth_hsh_t = "#{name}_hash_translations"
          class_eval <<-EVAL
            def #{meth_str_t}=(val)
              return self.#{meth_hsh_t} = {} if val.blank?
              _hash = {}
              self[:#{meth_str_t}] ||= {}
              I18n.available_locales.each do |l|
                begin
                  _hash[l] = JSON.parse(val[l])
                  self[:#{meth_str_t}][l]= val[l]
                rescue
                  self[:#{meth_str_t}][l]= val[l]
                end
              end
              self.#{meth_hsh_t} = _hash
            end
            def #{meth_str_t}
              self[:#{meth_str_t}] ||= self.#{meth} if self.#{meth}
            end
            def #{meth_str}
              self.#{meth_str_t}[I18n.locale] if self.#{meth_str_t}
            end
            def #{meth}
              self.#{meth_hsh}
            end
            def #{meth_json}
              self.#{meth_hsh}.to_json if self.#{meth_hsh}
            end

            validate do
              unless self.#{meth_hsh_t}.nil?
                _has_errors = false
                I18n.available_locales.each do |l|
                  I18n.with_locale(l) do
                    puts self.#{meth_hsh_t}[l]
                    puts self.#{meth_str}
                    puts "_"
                    if self.#{meth_hsh_t}[l].nil? and !self[:#{meth_str_t}][l].blank?
                      _has_errors ||= true
                      _meth = "#{meth_hsh_t}_\#{l}".to_s
                      self.errors.add(_meth, "Неверный формат данных")
                    else
                      self[:#{meth_str_t}].delete(l) if self[:#{meth_str_t}]
                    end
                  end
                end
                self.remove_attribute :#{meth_str_t} unless _has_errors
              end
              true
            end
          EVAL

        else
          class_eval <<-EVAL
            def #{meth_str}=(val)
              return self.#{meth_hsh} = {} if val.blank?
              begin
                self.#{meth_hsh} = JSON.parse(val)
              rescue
                self[:#{meth_str}] = val
              end
            end
            def #{meth_str}
              self[:#{meth_str}] ||= self.#{meth}.to_json if self.#{meth}
            end
            def #{meth}
              self.#{meth_hsh}
            end
            def #{meth_json}
              self.#{meth_hsh}.to_json if self.#{meth_hsh}
            end

            validate do
              unless self.#{meth}.nil?
                if self.#{meth_str} != self.#{meth}.to_json
                  self.errors.add(:#{meth}, "Неверный формат данных")
                else
                  self.remove_attribute :#{meth_str}
                end
                true
              end
            end
          EVAL
        end
      end
    end
  end
end
