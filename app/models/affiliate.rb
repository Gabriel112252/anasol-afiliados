class Affiliate < ApplicationRecord
  CPF_REGEX = /\A\d{3}\.\d{3}\.\d{3}-\d{2}\z/

  before_validation :normalize_tiktok

  validates :full_name,    presence: true
  validates :cpf,          presence: true, uniqueness: true,
                           format: { with: CPF_REGEX, message: "deve estar no formato 000.000.000-00" }
  validates :email,        presence: true, uniqueness: { case_sensitive: false },
                           format: { with: URI::MailTo::EMAIL_REGEXP, message: "inválido" }
  validates :whatsapp,     presence: true
  validates :tiktok,       presence: true
  validates :zip_code,     presence: true
  validates :street,       presence: true
  validates :number,       presence: true
  validates :neighborhood, presence: true
  validates :city,         presence: true
  validates :state,        presence: true
  validates :terms_accepted, acceptance: true
  validate  :cpf_valido

  private

  def normalize_tiktok
    return if tiktok.blank?
    self.tiktok = "@#{tiktok}" unless tiktok.start_with?("@")
  end

  def cpf_valido
    return if cpf.blank?
    digits = cpf.gsub(/\D/, "")
    return errors.add(:cpf, "inválido") unless digits.length == 11
    return errors.add(:cpf, "inválido") if digits.chars.uniq.length == 1

    [9, 10].each do |len|
      sum = digits[0, len].chars.each_with_index.sum { |d, i| d.to_i * (len + 1 - i) }
      r   = (sum * 10) % 11
      r   = 0 if r >= 10
      return errors.add(:cpf, "inválido") if r != digits[len].to_i
    end
  end
end
