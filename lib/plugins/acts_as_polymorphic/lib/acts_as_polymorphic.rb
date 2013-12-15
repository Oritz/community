module Sonkwo
  module Acts
    module PolymorphicAttributes
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_polymorphic(options = {})
          return if self.included_modules.include?(Sonkwo::Acts::PolymorphicAttributes::InstanceMethods)

          options.assert_valid_keys(:class_name, :name, :association)
          return unless options[:name]

          if options[:class_name] == nil
            belongs_to options[:name].to_sym, polymorphic: true
            return
          end

          send :include, Sonkwo::Acts::PolymorphicAttributes::InstanceMethods
          cattr_accessor :polymorphic_options
          options[:association] ||= options[:class_name].to_s.downcase
          self.polymorphic_options = options

          after_initialize :polymorphic_initialize
          after_save :polymorphic_save

          has_one self.polymorphic_options[:association].to_sym, as: options[:name]

          # Validations
          validate :common_must_be_validated

          define_common_accessors
        end

        private
        def define_common_accessors
          class_name = self.polymorphic_options[:class_name]
          association_name = self.polymorphic_options[:association]
          all_attributes = class_name.constantize.content_columns.map(&:name)
          ignored_attributes = ["#{name}_id", "#{name}_type"]
          attributes_to_delegate = all_attributes - ignored_attributes
          attributes_to_delegate.each do |attr|
            delegate attr, to: association_name
            #class_eval <<-RUBY
            #  def #{attr}
            #    #{association_name}.#{attr}
            #  end

            #  def #{attr}=(value)
            #    #{association_name}.#{attr} = value
            #  end

            #  def #{attr}?
            #    #{association_name}.#{attr}?
            #  end
            #RUBY
          end
        end
      end

      module InstanceMethods
        def self.included(base)
          base.extend ClassMethods
        end

        def method_missing(meth, *args, &blk)
          association_name = self.polymorphic_options[:association]
          send(association_name).send(meth, *args, &blk)
        rescue NoMethodError
          super
        end

        protected
        def common_must_be_validated
          association_name = self.polymorphic_options[:association]
          unless send(association_name).valid?
            send(association_name).errors.each do |attr, message|
              errors.add(attr, message)
            end
          end
        end

        def polymorphic_initialize
          association_name = self.polymorphic_options[:association]
          class_name = self.polymorphic_options[:class_name]
          unless self.id
            send("#{association_name}=", class_name.constantize.new)
          end
        end

        def polymorphic_save
          association_name = self.polymorphic_options[:association]
          name = self.polymorphic_options[:name]
          send(association_name).send("#{name}=", self)
          send(association_name).save
        end

        module ClassMethods
        end
      end
    end
  end
end
