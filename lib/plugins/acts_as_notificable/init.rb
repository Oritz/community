require File.dirname(__FILE__) + '/lib/acts_as_notificable'
ActiveRecord::Base.send(:include, Sonkwo::Acts::Notificable)
