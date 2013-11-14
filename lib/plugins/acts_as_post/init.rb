require File.dirname(__FILE__) + '/lib/acts_as_post'
ActiveRecord::Base.send(:include, Sonkwo::Acts::PostAttributes)
