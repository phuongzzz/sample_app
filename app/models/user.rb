class User < ApplicationRecord
  attr_accessor :remember_token
  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: Settings.validates.name.presence,
    length: {maximum: Settings.validates.name.length}
  validates :email, presence: Settings.validates.email.presence,
    length: {maximum: Settings.validates.email.length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: Settings.validates.email.case_sensitive}
  validates :password, presence: Settings.validates.password.presence,
    length: {minimum: Settings.validates.password.length},
    allow_nil: true

  has_secure_password

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def current_user? user
    self == user
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attributes remember_digest: nil
  end

  class << self
    def digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private
  def downcase_email
    self.email = self.email.downcase
  end
end
