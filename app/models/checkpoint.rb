class Checkpoint < ApplicationRecord
  belongs_to :competition
  has_many :entries, dependent: :destroy

  validates :name, :end_time, :max_national_challenges,
            :max_regional_challenges, presence: true

  def limit_reached?(team, region)
    if region.national?
      max = max_national_challenges
      entry_count = team.national_challenges(self).count
    else
      max = max_regional_challenges
      entry_count = team.regional_challenges(self).count
    end
    return false if entry_count < max
    true
  end

  def passed?(team)
    end_time.to_formatted_s(:number) < Time.now.in_time_zone(team.time_zone).to_formatted_s(:number)
  end
end
