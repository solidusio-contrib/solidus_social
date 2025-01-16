# frozen_string_literal: true

class Spree::UserAuthenticationsController < Spree::BaseController
  include RouteResolver

  def index
    @authentications = spree_current_user.user_authentications if spree_current_user
  end

  def destroy
    @authentication = spree_current_user.user_authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = I18n.t('spree.destroy', scope: :authentications)
    redirect_to resolve_route_for(:account_path)
  end
end
