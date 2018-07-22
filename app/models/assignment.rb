class Assignment < ApplicationRecord
  belongs_to :assignable, polymorphic: true
  belongs_to :user

  validates :title, presence: true
  validates :title, inclusion: { in: VALID_ASSIGNMENT_TITLES }
end
