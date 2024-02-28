# frozen_string_literal: true

class User < ApplicationRecord
  attr_accessor :remember_token

  VALIDATE_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password
  before_save :downcase

  validates :name, presence: true, length: { maximum: Settings.DIGIT_50 }

  validates :email, presence: true, length: { maximum: Settings.DIGIT_255 },
                    format: { with: VALIDATE_EMAIL_REGEX }, uniqueness: true

  validates :birthday, :gender, presence: true
  validate :birthday_within_last_100_years

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

  def authenticate?(remember_token)
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  private

  def downcase
    email.downcase!
  end

  def birthday_within_last_100_years
    return unless birthday < Settings.HUNDRED_YEARS.years.ago.to_date

    errors.add(:birthday, :birthday_within_last_100_years)
  end
end
