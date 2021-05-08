class Dataset < ApplicationRecord
  scope :search, lambda { |term|
    where 'datasets.name ILIKE ? OR url ILIKE ? OR description ILIKE ?',
    "%#{term}%", "%#{term}%", "%#{term}%"
  }

  validates :name, presence: true
end
