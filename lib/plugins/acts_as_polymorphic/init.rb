require File.dirname(__FILE__) + '/lib/acts_as_polymorphic'
ActiveRecord::Base.send(:include, Sonkwo::Acts::PolymorphicAttributes)
