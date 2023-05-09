# == Schema Information
#
# Table name: favourites
#
#  id            :bigint           not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  assignment_id :integer
#  holder_id     :integer
#  team_id       :integer
#
# Indexes
#
#  index_favourites_on_assignment_id  (assignment_id)
#  index_favourites_on_holder_id      (holder_id)
#  index_favourites_on_team_id        (team_id)
#
class Favourite < ApplicationRecord
  belongs_to :team
  belongs_to :holder
  belongs_to :assignment

  has_one :project, through: :team, source: :current_project

  validates :team, uniqueness: { scope: :assignment }
end
