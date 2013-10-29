module Voima
  class Authorization < ActiveRecord::Base

    belongs_to :role
    belongs_to :user

    validates_presence_of :user_id, :role_id

    attr_accessor :controller, :action

    after_save :clear_cache
    after_destroy :clear_cache

    def can? controller, action, params
      resource = controller.classify.constantize
      @controller = controller
      @action = action
      set_dependent(resource, params)
      cached_actions.include?([controller, action, dependent_id]) || cached_actions.include?([controller, action, nil])
    end

    def set_dependent resource, params
      self.dependent_id = resource.get_dependent_id(params) if resource.methods.include? :get_dependent_id
    end

    private
    def clear_cache
      Rails.cache.delete key_cache
    end

    def key_cache
      "#{user.email}_allowed_actions"
    end

    def cached_actions
      write_on_cache
      Rails.cache.read key_cache
    end

    def write_on_cache
      Rails.cache.write key_cache, allowed_actions unless Rails.cache.exist? key_cache
    end

    def allowed_actions
      auths = Voima::Authorization.
                joins(:role => :features).
                where(:voima_roles => {:organization_id => user.last_organization_logged}, :voima_authorizations => {:user_id => user.id}).
                includes(:role => :features)
      auths_hash = auths.map{|auth| {:features => auth.role.features, :dependent_id => auth.dependent_id}}
      auths_hash.map{|auth| auth[:features].map{|feature| [feature[:controller], feature[:action], (feature[:requires_dependent] ? auth[:dependent_id] : nil) ]}}.flatten(1)
    end

  end
end
