# == Schema Information
#
# Table name: favourites
#
#  id            :bigint           not null, primary key
#  assignment_id :integer
#  team_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  holder_id     :integer
#
class Favourite < ApplicationRecord
  belongs_to :team
  belongs_to :holder
  belongs_to :assignment

  has_one :project, through: :team, source: :current_project

  validates :team, uniqueness: { scope: :assignment }
end
