module Sonkwo
  module Acts
    module Tipoffable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_tipoffable(*args)
          return if self.included_modules.include?(Sonkwo::Acts::Tipoffable::InstanceMethods)
          options = args.empty? ? {} : args[0]
          options.assert_valid_keys(:target)

          send :include, Sonkwo::Acts::Tipoffable::InstanceMethods

          has_one :tipoff, as: :detail

          cattr_accessor :tipoff_options
          self.tipoff_options = options
        end
      end

      module InstanceMethods
        def tipoff_target
          if self.class.tipoff_options[:target]
            self.send(self.class.tipoff_options[:target])
          else
            self
          end
        end
      end
    end
  end
end
