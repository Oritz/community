module Sonkwo
  module Acts
    module Notificable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_notificable(options = {})
          return if self.included_modules.include?(Sonkwo::Acts::Notificable::InstanceMethods)
          options.assert_valid_keys(:callbacks, :slot, :tos, :from)

          send :include, Sonkwo::Acts::Notificable::InstanceMethods

          options[:tos] ||= []

          cattr_accessor :notificable_options
          self.notificable_options = options
          # Callbacks
          options[:callbacks].each do |item|
            case item.to_s
            when "after_create"
              after_create :notify
            when "after_save"
              after_save :notify
            when "after_validation"
              after_validation :notify
            else
              raise "#{item} is not supported."
            end
          end
        end
      end

      module InstanceMethods
        protected
        def notify(*args)
          return unless self.class.notificable_options[:slot]

          slot = self.class.notificable_options[:slot]
          tos = self.class.notificable_options[:tos]
          from = self.class.notificable_options[:from]

          from_account = self.send(from.to_s) if from
          tos.each do |to|
            to_account = nil

            tmp = to.to_s.split(".")
            to_account = self if tmp.count > 0
            tmp.each { |item| to_account = to_account.send(item) }
            next unless to_account
            next if from && from_account == to_account

            notification = to_account.notification
            notification.send("#{slot}=", notification.send(slot) + 1)
            notification.save!
          end
        end
      end
    end
  end
end
