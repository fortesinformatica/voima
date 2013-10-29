module Voima
  class FeaturesRoles < ActiveRecord::Base
    belongs_to :role
    belongs_to :feature
  end
end
