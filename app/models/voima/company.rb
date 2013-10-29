module Voima
  class Company < ActiveRecord::Base
    belongs_to :organization
  end
end
