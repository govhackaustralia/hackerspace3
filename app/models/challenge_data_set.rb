# == Schema Information
#
# Table name: challenge_data_sets
#
#  id           :bigint           not null, primary key
#  challenge_id :integer
#  data_set_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class ChallengeDataSet < ApplicationRecord
  belongs_to :challenge
  belongs_to :data_set

  validates :challenge_id, uniqueness: { scope: :data_set_id,
                                         message: 'Challenge Data Set already exists' }
end
