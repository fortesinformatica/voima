module Voima
  class Authorization < ActiveRecord::Base
    belongs_to :company
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
      set_company(resource, params) unless resource.attribute_method? :organization_id
      cached_actions.include?([controller, action, company_id]) || cached_actions.include?([controller, action, nil])
    end

    def set_company resource, params
      id_from_company = resource.get_company_id(params)
      self.company = Voima::Company.find( id_from_company ) if id_from_company.present?
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
                where(:roles => {:organization_id => user.last_organization_logged}, :authorizations => {:user_id => user.id}).
                includes(:role => :features)
      auths_hash = auths.map{|auth| {:features => auth.role.features, :company_id => auth.company_id}}
      auths_hash.map{|auth| auth[:features].map{|feature| [feature[:controller], feature[:action], (feature[:requires_company] ? auth[:company_id] : nil) ]}}.flatten(1)
    end

  end
end
