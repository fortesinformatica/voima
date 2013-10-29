module Voima
  class FeaturesRole < ActiveRecord::Base
    belongs_to :role
    belongs_to :feature
  end
end
