module Sonkwo
  module Acts
    module BehaviorProvider
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_behavior_provider(options = {})
          unless self.included_modules.include?(Sonkwo::Acts::BehaviorProvider::InstanceMethods)
            cattr_accessor :provider_options
            send :include, Sonkwo::Acts::BehaviorProvider::InstanceMethods
          end

          options.assert_valid_keys(:timestamp, :status, :author_key, :find_options, :joins)
          self.provider_options ||= {}

          options[:timestamp] ||= "#{table_name}.created_at"
          options[:status] ||= "#{table_name}.status"
          options[:find_options] ||= {}
          options[:joins] ||= ""
          options[:author_key] = "#{table_name}.#{options[:author_key]}" if options[:author_key].is_a?(Symbol)

          self.provider_options = options
        end

        def find_behaviors(user, options)
          options.assert_valid_keys(:from, :to, :limit, :order, :author, :min_id, :max_id, :status)

          # TODO: user is used for permission (visiable)
          scope = self
          scope = scope.joins(self.provider_options[:joins]) if self.provider_options[:joins]

          if options[:limit]
            scope = scope.limit(options[:limit])
          end

          if options[:order]
            scope = scope.order(options[:order])
          end

          if options[:from] & options[:to]
            scope = scope.where("#{self.provider_options[:timestamp]} BETWEEN ? TO ?", options[:from], options[:to])
          elsif options[:from]
            scope = scope.where("#{self.provider_options[:timestamp]} >= ?", options[:from])
          elsif options[:to]
            scope = scope.where("#{self.provider_options[:timestamp]} <= ?", options[:to])
          end

          if options[:min_id] & options[:max_id]
            scope = scope.where("#{self.table_name}.#{self.primary_key} BETWEEN ? TO ?", options[:min_id], options[:max_id])
          elsif options[:min_id]
            scope = scope.where("#{self.table_name}.#{self.primary_key} > ?", options[:min_id])
          elsif options[:max_id]
            scope = scope.where("#{self.table_name}.#{self.primary_key} < ?", options[:max_id])
          end

          if options[:status]
            scope = scope.where("#{self.provider_options[:status]} = ?", options[:status])
          end

          if options[:author]
            scope = scope.where("#{self.provider_options[:author_key]} = ?", options[:author].id)
          else
            tmps = Friendship.where("follower_id=?", user.id)
            ids = tmps.collect {|x| x.account_id}
            ids << user.id
            scope = scope.where("#{self.provider_options[:author_key]} IN (?)", ids)
          end

          scope.all(self.provider_options[:find_options].dup)
        end
      end

      module InstanceMethods
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
        end
      end
    end
  end
end
