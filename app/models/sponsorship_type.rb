class SponsorshipType < ApplicationRecord
  belongs_to :competition

  has_many :sponsorships, dependent: :destroy
  has_many :sponsors, through: :sponsorships

  validates :name, :position, presence: true

  # Reorders the Sponsorship types that have been displaced when the position
  # attribute is changed.
  # ENHANCEMENT: Add to a callback?
  # ENHANCEMENT: Add a validation to inforce?
  def self.reorder_from(from)
    placeholder = from
    all.order(position: :asc).each do |sponsorship_type|
      next if sponsorship_type.position < placeholder
      break if sponsorship_type.position != placeholder

      sponsorship_type.update(position: placeholder += 1)
    end
  end
end
