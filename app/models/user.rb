class User < ApplicationRecord
  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: Settings.validates.name.presence,
    length: {maximum: Settings.validates.name.length}
  validates :email, presence: Settings.validates.email.presence,
    length: {maximum: Settings.validates.email.length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: Settings.validates.email.case_sensitive}
  validates :password, presence: Settings.validates.password.presence,
    length: {minimum: Settings.validates.password.length}

  has_secure_password

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end
  end

  private
  def downcase_email
    self.email = self.email.downcase
  end
end
