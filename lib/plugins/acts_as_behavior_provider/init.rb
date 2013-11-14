require File.dirname(__FILE__) + '/lib/acts_as_behavior_provider'
ActiveRecord::Base.send(:include, Sonkwo::Acts::BehaviorProvider)
