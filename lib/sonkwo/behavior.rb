module Sonkwo
  module Behavior
    class << self
      attr_reader :default_behavior_types, :available_behavior_types, :providers

      def register(behavior_type, options={})
        options.assert_valid_keys(:class_name, :default)

        behavior_type = behavior_type.to_s

        @default_behavior_types ||= []
        @available_behavior_types ||= []
        @providers ||= {}

        @available_behavior_types << behavior_type unless @available_behavior_types.include?(behavior_type)
        @default_behavior_types << behavior_type unless options[:default] == false
        providers = options[:class_name] || behavior_type.classify
        providers = ([] << providers) unless providers.is_a?(Array)
        @providers[behavior_type] ||= []
        @providers[behavior_type] += providers
      end
    end
  end
end
