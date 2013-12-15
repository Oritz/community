module Sonkwo
  module Acts
    module PostAttributes
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_post(options = {})
          return if self.included_modules.include?(Sonkwo::Acts::PostAttributes::InstanceMethods)

          options.assert_valid_keys(:find_options, :subpost)
          send :include, Sonkwo::Acts::PostAttributes::InstanceMethods

          cattr_accessor :post_options
          options[:find_options] ||= {}
          self.post_options = options

          belongs_to :post, class_name: 'Post', foreign_key: 'id', dependent: :destroy

          # Validations
          validate :post_must_be_validated

          define_post_accessors
        end

        private
        def define_post_accessors
          all_attributes = Post.content_columns.map(&:name)
          ignored_attributes = ['post_type']
          attributes_to_delegate = all_attributes - ignored_attributes
          attributes_to_delegate.each do |attr|
            class_eval <<-RUBY
              def #{attr}
                post.#{attr}
              end

              def #{attr}=(value)
                post.#{attr} = value
              end

              def #{attr}?
                post.#{attr}?
              end
            RUBY
          end
        end
      end

      module InstanceMethods
        def self.included(base)
          base.extend ClassMethods
        end

        def method_missing(meth, *args, &blk)
          post.send(meth, *args, &blk)
        rescue NoMethodError
          super
        end

        protected
        def post_must_be_validated
          unless post.valid?
            post.errors.each do |attr, message|
              errors.add(attr, message)
            end
          end
        end

        module ClassMethods
        end
      end
    end
  end
end
