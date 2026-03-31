# frozen_string_literal: true

class Merchant < ApplicationRecord
  has_one_attached :scan_sound

  # Relations
  has_many :order_batches

  # Ransack
  def self.ransackable_attributes(auth_object = nil)
    %w[id name marketplace is_active]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # Normalization
  normalizes :name, with: ->(e) { e.to_s.strip.titleize }
  normalizes :marketplace, with: ->(e) { e.to_s.strip.titleize }

  # Validations
  validates :name, presence: true, length: { maximum: 100 }
  validates :marketplace, presence: true, length: { maximum: 50 }

  validate :scan_sound_format

  private

  def scan_sound_format
    return unless scan_sound.attached?

    unless scan_sound.content_type.in?(%w[
                                         audio/mpeg
                                         audio/mp3
                                         audio/wav
                                         audio/x-wav
                                         audio/ogg
                                       ])
      errors.add(:scan_sound, 'must be a valid audio file (mp3, wav, ogg)')
    end
  end
end
