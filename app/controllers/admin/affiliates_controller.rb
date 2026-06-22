require "csv"

class Admin::AffiliatesController < Admin::BaseController
  before_action :set_affiliate, only: [:show, :edit, :update]

  def index
    @query      = params[:q].to_s.strip
    @affiliates = Affiliate.order(created_at: :desc)

    if @query.present?
      like = "%#{@query}%"
      @affiliates = @affiliates.where(
        "full_name LIKE :q OR cpf LIKE :q OR email LIKE :q OR city LIKE :q",
        q: like
      )
    end

    respond_to do |format|
      format.html { @affiliates = @affiliates.page(params[:page]).per(25) }
      format.csv  { send_csv_download(@affiliates) }
    end
  end

  def show; end

  def edit; end

  def update
    if @affiliate.update(affiliate_params)
      redirect_to admin_affiliate_path(@affiliate), notice: "Cadastro atualizado com sucesso."
    else
      flash.now[:alert] = "Erro ao atualizar cadastro."
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_affiliate
    @affiliate = Affiliate.find(params[:id])
  end

  def affiliate_params
    params.require(:affiliate).permit(
      :full_name, :cpf, :email, :whatsapp, :tiktok,
      :zip_code, :street, :number, :complement, :neighborhood, :city, :state,
      :terms_accepted
    )
  end

  def send_csv_download(scope)
    filename = "afiliadas_anasol_#{Date.today}.csv"
    data = CSV.generate(headers: true, encoding: "UTF-8") do |csv|
      csv << ["Nome", "CPF", "E-mail", "WhatsApp", "TikTok", "CEP", "Rua", "Número",
              "Complemento", "Bairro", "Cidade", "Estado", "Aceite Termos", "Data Cadastro"]
      scope.each do |a|
        csv << [
          a.full_name, a.cpf, a.email, a.whatsapp, a.tiktok,
          a.zip_code, a.street, a.number, a.complement,
          a.neighborhood, a.city, a.state,
          a.terms_accepted? ? "Sim" : "Não",
          a.created_at.strftime("%d/%m/%Y %H:%M")
        ]
      end
    end
    send_data "\xEF\xBB\xBF#{data}",
              filename:    filename,
              type:        "text/csv; charset=utf-8",
              disposition: "attachment"
  end
end
