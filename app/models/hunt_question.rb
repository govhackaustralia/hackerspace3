# == Schema Information
#
# Table name: hunt_questions
#
#  id             :bigint           not null, primary key
#  competition_id :integer
#  question       :string
#  answer         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class HuntQuestion < ApplicationRecord
  belongs_to :competition

  validates :question, :answer, presence: true

  def name
    question
  end
end
