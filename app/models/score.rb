# frozen_string_literal: true

# == Schema Information
#
# Table name: scores
#
#  id           :bigint           not null, primary key
#  entry        :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  criterion_id :integer
#  header_id    :integer
#
# Indexes
#
#  index_scores_on_criterion_id  (criterion_id)
#  index_scores_on_header_id     (header_id)
#
class Score < ApplicationRecord
  belongs_to :header
  belongs_to :criterion

  validates :header_id, uniqueness: {
    scope: :criterion_id,
    message: 'Score already exists.'
  }
end
