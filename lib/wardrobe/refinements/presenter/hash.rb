# frozen_string_literal: true

module Wardrobe
  module Refinements
    module Presenter
      refine Hash do
        def _set_at(value, segments)
          segment = segments.shift
          if segments.empty?
            self[segment] = value
          else
            self[segment] ||= {}
            self[segment]._set_at(value, segments)
          end
        end
        def _present(attributes: nil, **options)
          options[:path] ||= []
          options[:path] << self
          key_atrs = attributes&.dig(:_key)
          val_atrs = attributes&.dig(:_val)
          present_some = attributes && (attributes.keys - [:_val, :_key]).any?
          {}.tap do |res|
            each do |k,v|
              if present_some
                next unless attributes[k]
              end
              key = k._present(attributes: key_atrs, **options)
              val = if present_some
                      v._present(attributes: val_atrs.merge(attributes[k]), **options)
                    else
                      v._present(attributes: val_atrs, **options)
                    end
              res[key] = val
            end
          end
        ensure
          options[:path].pop
        end
      end
    end
  end
end
