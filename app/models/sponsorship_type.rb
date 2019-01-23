class SponsorshipType < ApplicationRecord
  belongs_to :competition

  has_many :sponsorships, dependent: :destroy

  validates :name, :order, presence: true

  # Reorders the Sponsorship types that have been displaced when the order
  # attribute is changed.
  # ENHANCEMENT: Add to a callback?
  # ENHANCEMENT: Add a validation to inforce?
  def self.reorder_from(from)
    placeholder = from
    all.order(order: :asc).each do |type|
      next if type.order < placeholder
      break if type.order != placeholder

      type.update(order: placeholder += 1)
    end
  end
end
