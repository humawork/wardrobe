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
          {}.tap do |res|
            each do |k,v|
              key = k._present(attributes: key_atrs, **options)
              val = v._present(attributes: val_atrs, **options)
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
