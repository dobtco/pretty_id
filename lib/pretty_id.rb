require 'pretty_id/core'
ActiveRecord::Base.send :include, PrettyId::Core
