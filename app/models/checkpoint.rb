class Checkpoint < ApplicationRecord
  belongs_to :competition
  has_many :entries, dependent: :destroy

  validates :name, :end_time, :max_national_challenges,
            :max_regional_challenges, presence: true

  # Returns a boolean based on whether a team has reached the maximum
  # number of challenges for a particular region.
  def limit_reached?(team, region)
    if region.international? || region.national?
      team.national_challenges(self).count >= max_national_challenges
    else
      team.regional_challenges(self).count >= max_regional_challenges
    end
  end

  # Returns a boolean based on whether a checkpoint has passed in a given
  # time zone.
  def passed?(time_zone)
    end_time.to_formatted_s(:number) < Time.now.in_time_zone(
      time_zone.presence || COMP_TIME_ZONE
    ).to_formatted_s(:number)
  end
end
