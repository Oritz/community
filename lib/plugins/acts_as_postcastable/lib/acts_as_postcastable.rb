module Sonkwo
  module Acts
    module Postcastable
      def self.included(base)
        base.extend ClassMethods
      end

      def self.get_post_by_key(obj, post_key)
        return nil unless obj
        post = obj
        if post_key
          tmp = post_key.split(".")
          tmp.each {|x| post = post.send(x)}
        end
        post
      end

      def self.set_post_by_key(obj, post_key, post)
        if post_key
          tmp = post_key.split(".")
          tmp.each {|x| obj = obj.send(x)}
          obj.send("cast=", post)
        end
        post
      end

      module ClassMethods
        def acts_as_postcastable
          return if self.included_modules.include?(Sonkwo::Acts::Postcastable::InstanceMethods)
          send :include, Sonkwo::Acts::Postcastable::InstanceMethods

          class << self
            def downcast(list, post_key=nil)
              return nil unless list
              Sonkwo::PostType.submodels.each do |submodel, options|
                sub_ids = []
                sub_indexs = []
                list.each_with_index do |item, index|
                  post = Sonkwo::Acts::Postcastable.get_post_by_key(item, post_key)
                  next unless post
                  if post.post_type == options[:post_type]
                    sub_ids << post.id unless sub_ids.include?(post.id)
                    sub_indexs << index
                  end
                end
                next if sub_ids.count == 0

                submodel_class = options[:class_name].to_s.constantize
                sub_list = submodel_class.where("id in (?)", sub_ids)
                sub_list = sub_list.all(submodel_class.post_options[:find_options].dup)
                sub_indexs.each_with_index do |index, i|
                  post = Sonkwo::Acts::Postcastable.get_post_by_key(list[index], post_key)
                  sub = nil
                  sub_list.each do |item|
                    if post.id == item.id
                      sub = item
                      break
                    end
                  end
                  sub.post = post
                  if post_key
                    Sonkwo::Acts::Postcastable.set_post_by_key(list[index], post_key, sub)
                  else
                    list[index].cast = sub
                  end
                end

                if submodel_class.post_options[:subpost]
                  subposts = sub_list.collect { |x| x.send(submodel_class.post_options[:subpost]) }
                  subposts = downcast(subposts)
                end
              end
              list
            end
          end
        end
      end

      module InstanceMethods
        def cast
          return @cast if @cast
          new_post = nil
          class_name = nil
          Sonkwo::PostType.submodels.each do |submodel, options|
            if options[:post_type] == self.post_type
              class_name = options[:class_name].to_s
              break;
            end
          end
          return self unless class_name

          new_post = class_name.constantize.new
          new_post.post = self
          new_post.id = self.id
          new_post.reload
          @cast = new_post
          @cast
        end

        def cast=(cast)
          @cast = cast
        end
      end
    end
  end
end
