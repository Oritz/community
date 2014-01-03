require File.dirname(__FILE__) + '/lib/acts_as_tipoffable'
ActiveRecord::Base.send(:include, Sonkwo::Acts::Tipoffable)
