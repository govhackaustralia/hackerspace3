class HuntQuestion < ApplicationRecord
  belongs_to :competition

  validates :question, :answer, presence: true

  alias_method :name, :question
end
