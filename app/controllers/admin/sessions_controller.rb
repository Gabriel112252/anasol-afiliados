class Admin::SessionsController < ApplicationController
  layout "admin"

  def new
    redirect_to admin_affiliates_path if session[:admin_id]
  end

  def create
    admin = Admin.find_by(email: params[:email].to_s.downcase.strip)

    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_affiliates_path, notice: "Bem-vinda!"
    else
      flash.now[:alert] = "E-mail ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:admin_id)
    redirect_to admin_login_path, notice: "Sessão encerrada."
  end
end
