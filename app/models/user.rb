# frozen_string_literal: true

class User < ApplicationRecord
  VALIDATE_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password
  before_save :downcase

  validates :name, presence: true, length: { maximum: Settings.DIGIT_50 }

  validates :email, presence: true, length: { maximum: Settings.DIGIT_255 },
                    format: { with: VALIDATE_EMAIL_REGEX }, uniqueness: true

  validates :birthday, :gender, presence: true
  validate :birthday_within_last_100_years

  def self.digest(string)
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost
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
