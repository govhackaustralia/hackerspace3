# == Schema Information
#
# Table name: team_data_sets
#
#  id                 :bigint           not null, primary key
#  team_id            :integer
#  name               :string
#  description        :text
#  description_of_use :text
#  url                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class TeamDataSet < ApplicationRecord
  belongs_to :team

  has_one :current_project, through: :team

  validates :name, presence: true
end
