# frozen_string_literal: true

class Micropost < ApplicationRecord
  belongs_to :user
  scope :newest, -> { order(created_at: :desc) }
  has_one_attached :image
  validates :content, presence: true, length: { maximum: Settings.DIGIT_140 }
  validates :image, content_type: { in: %w(image/jpeg image/gif image/png), message: I18n.t("must_be_valid") }
end
