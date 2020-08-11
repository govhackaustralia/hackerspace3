class HuntQuestion < ApplicationRecord
  belongs_to :competition

  validates :question, :answer, presence: true
end
