# == Schema Information
#
# Table name: team_data_sets
#
#  id                 :bigint           not null, primary key
#  description        :text
#  description_of_use :text
#  name               :string
#  url                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  team_id            :integer
#
# Indexes
#
#  index_team_data_sets_on_team_id  (team_id)
#
class TeamDataSet < ApplicationRecord
  belongs_to :team

  has_one :current_project, through: :team

  validates :name, presence: true
end
