# == Schema Information
#
# Table name: criteria
#
#  id             :bigint           not null, primary key
#  competition_id :integer
#  description    :text
#  category       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  name           :string
#
class Criterion < ApplicationRecord
  belongs_to :competition
  has_many :scores

  validates :name, :description, presence: true
  validates :category, inclusion: { in: JUDGEMENT_CATEGORIES }
end
