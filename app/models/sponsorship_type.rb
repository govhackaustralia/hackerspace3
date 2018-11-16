class SponsorshipType < ApplicationRecord
  belongs_to :competition
  has_many :sponsorships, dependent: :destroy

  def self.reorder_from(from)
    placeholder = from
    all.order(order: :asc).each do |type|
      next if type.order < placeholder
      break if type.order != placeholder

      type.update(order: placeholder += 1)
    end
  end
end
