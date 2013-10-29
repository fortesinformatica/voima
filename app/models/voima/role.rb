module Voima
  class Role < ActiveRecord::Base
    belongs_to :organization

    validates :name, :presence => true

    has_many :features_roles
    has_many :features, :through => :features_roles

  end
end
