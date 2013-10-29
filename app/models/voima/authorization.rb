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
      unless resource.attribute_method? :organizacao_id
        id_da_empresa = resource.get_empresa_id(params)
        self.empresa = Empresa.find( id_da_empresa ) if id_da_empresa.present?
      end
      #se tem permissão exclusiva para uma empresa ou se tem para toda a organização
      cached_actions.include?([controller, action, empresa_id]) || cached_actions.include?([controller, action, nil])
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
      auths = Autorizacao.joins(:role => :features).where(:roles => {:organizacao_id => user.ultima_organizacao_logada_id}, :autorizacoes => {:user_id => user.id}).includes(:role => :features)
      auths_hash = auths.map{|auth| {:features => auth.role.features, :empresa_id => auth.empresa_id}}
      auths_hash.map{|auth| auth[:features].map{|feature| [feature[:controller], feature[:action], (feature[:exige_empresa] ? auth[:empresa_id] : nil) ]}}.flatten(1)
    end

  end
end
