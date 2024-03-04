# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  VALIDATE_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save :downcase
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: Settings.DIGIT_50 }

  validates :email, presence: true, length: { maximum: Settings.DIGIT_255 },
                    format: { with: VALIDATE_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true,
                       length: { minimum: Settings.DIGIT_6 }, allow_nil: true

  validates :birthday, :gender, presence: true

  validate :birthday_within_last_100_years, if: -> { birthday.present? }

  scope :sort_by_name, -> { order(:name) }
  has_secure_password

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end

    def digest(string)
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticate?(attribute, token)
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 1.hours.ago
  end

  private

  def downcase
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end

  def birthday_within_last_100_years
    return unless birthday < Settings.HUNDRED_YEARS.years.ago.to_date

    errors.add(:birthday, :birthday_within_last_100_years)
  end
end
