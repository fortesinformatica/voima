module Voima
  class Role < ActiveRecord::Base
    belongs_to :organization
  end
end
