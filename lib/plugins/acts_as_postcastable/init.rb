require File.dirname(__FILE__) + '/lib/acts_as_postcastable'
ActiveRecord::Base.send(:include, Sonkwo::Acts::Postcastable)
