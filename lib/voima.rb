require "voima/engine"

module Voima

  module Controllers
    autoload :Helpers, 'voima/controllers/helpers'
  end

  ActiveSupport.on_load(:action_controller) do

    self.class_eval do
      include Voima::Controllers::Helpers
    end

  end

end
