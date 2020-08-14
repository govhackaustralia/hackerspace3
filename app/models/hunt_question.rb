class HuntQuestion < ApplicationRecord
  belongs_to :competition

  validates :question, :answer, presence: true

  def name
    question
  end
end
