module Sonkwo
  module PostType
    class << self
      attr_reader :submodels

      def regist_submodel(submodel, options={})
        options.assert_valid_keys(:class_name, :post_type)
        options[:class_name] ||= submodel.to_s
        options[:post_type] ||= Post::TYPE_TALK

        @submodels ||= {}
        @submodels[submodel] = options unless @submodels.include?(submodel)
      end
    end
  end
end
