module Voima
  module Controllers
    # Those helpers are convenience methods added to ApplicationController.
    module Helpers
      extend ActiveSupport::Concern

      included do
        append_before_filter :authorize_user!

        before_filter only: :destroy do |controller|
          if controller.is_a? Devise::SessionsController
            Rails.cache.delete Authorization.new(:user_id => current_user.id).send(:key_cache)
          end
        end

      end

      def authorize_user!
        if current_user.present? && !is_a?(DeviseController) && cannot?(params[:controller], self.action_name, params)
          render_error_with "Sem autorização", :unauthorized
        end
      end

      def can? controller, action, params
        current_user.admin? || Authorization.new(:user => current_user).can?(controller, action, params)
      end

      def cannot? controller, action, params
        !can? controller, action, params
      end

      def render_error_with message, status
        respond_to do |format|
          format.html {
            render "Error", :layout => "error", :locals => { :message => message }, :status => status
          }
          format.json {
            render :json => {
                :message => message
            }, :status => status
          }
          format.sencha {
            render :json => {
                :message => message
            }, :status => status
          }
        end
      end

    end

  end

end
