# frozen_string_literal: true

# == Schema Information
#
# Table name: criteria
#
#  id             :bigint           not null, primary key
#  category       :string
#  description    :text
#  name           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  competition_id :integer
#
# Indexes
#
#  index_criteria_on_competition_id  (competition_id)
#
class Criterion < ApplicationRecord
  belongs_to :competition
  has_many :scores

  validates :name, :description, presence: true
  validates :category, inclusion: {in: JUDGEMENT_CATEGORIES}
end
