class LandingController < ApplicationController
  def index
    @affiliate = Affiliate.new
  end

  def create
    @affiliate = Affiliate.new(affiliate_params)

    if @affiliate.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("form-container", partial: "landing/success") }
        format.html         { redirect_to root_path }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "form-container",
            partial: "landing/form",
            locals:  { affiliate: @affiliate }
          ), status: :unprocessable_entity
        end
        format.html { render :index, status: :unprocessable_entity }
      end
    end
  end

  private

  def affiliate_params
    params.require(:affiliate).permit(
      :full_name, :cpf, :email, :whatsapp, :tiktok,
      :zip_code, :street, :number, :complement, :neighborhood, :city, :state,
      :terms_accepted
    )
  end
end
