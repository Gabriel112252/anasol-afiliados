class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    unless session[:admin_id]
      redirect_to admin_login_path, alert: "Faça login para continuar."
    end
  end

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end
  helper_method :current_admin
end
