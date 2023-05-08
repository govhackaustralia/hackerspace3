# == Schema Information
#
# Table name: scores
#
#  id           :bigint           not null, primary key
#  header_id    :integer
#  criterion_id :integer
#  entry        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Score < ApplicationRecord
  belongs_to :header
  belongs_to :criterion

  validates :header_id, uniqueness: { scope: :criterion_id,
                                         message: 'Score already exists.' }
end
