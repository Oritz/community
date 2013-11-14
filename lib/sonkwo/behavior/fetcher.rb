module Sonkwo
  module Behavior
    class Fetcher
      attr_reader :account, :target, :scope

      def initialize(account, options={})
        options.assert_valid_keys(:target)
        @account = account
        @target = options[:target]

        @scope = Sonkwo::Behavior.available_behavior_types
      end

      def scope=(s)
        case s
        when :all
          @scope = Sonkwo::Behavior.available_behavior_types
        when :default
          default_scope
        else
          @scope = s & behavior_types
        end
      end

      def behaviors(options={})
        options.assert_valid_keys(:from, :to, :limit, :order, :max_id, :min_id, :status)
        options[:author] = @target if @target

        results = []

        @scope.each do |behavior_type|
          # fetch behaviors
          providers = Sonkwo::Behavior.providers[behavior_type]
          providers.each do |provider|
            results += provider.constantize.find_behaviors(account, options)
          end
        end

        results = results.sort {|a, b| b.created_at <=> a.created_at}

        if options[:limit]
          results = results.slice(0, options[:limit])
        end

        results
      end

      protected
      def default_scope
        @scope = Sonkwo::Behavior.default_behavior_types
      end
    end
  end
end
