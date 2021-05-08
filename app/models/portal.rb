class Portal < ApplicationRecord
  belongs_to :portable, polymorphic: true
  belongs_to :dataset

  has_one :extra, dependent: :destroy

  validates :dataset_id, uniqueness: {
    scope: %i[portable_id portable_type],
    message: 'Portal already exists'
  }
end
