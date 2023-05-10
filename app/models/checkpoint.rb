# frozen_string_literal: true

# == Schema Information
#
# Table name: checkpoints
#
#  id                      :bigint           not null, primary key
#  end_time                :datetime
#  max_national_challenges :integer
#  max_regional_challenges :integer
#  name                    :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  competition_id          :integer
#
# Indexes
#
#  index_checkpoints_on_competition_id  (competition_id)
#
class Checkpoint < ApplicationRecord
  belongs_to :competition
  has_many :entries, dependent: :destroy
  has_many :region_limits

  validates :name, :end_time, :max_national_challenges,
            :max_regional_challenges, presence: true

  # Returns a boolean based on whether a team has reached the maximum
  # number of challenges for a particular region.
  # ERROR: Not working correctly at the moment
  def limit_reached?(team, region)
    if region.international? || region.national?
      team.national_challenges(self).count >= max_national(region)
    else
      team.regional_challenges(self).count >= max_regional(region)
    end
  end

  # Returns a boolean based on whether a checkpoint has passed in a given
  # time zone.
  def passed?(time_zone)
    end_time.to_formatted_s(:number) < Time.now.in_time_zone(
      time_zone.presence || LAST_COMPETITION_TIME_ZONE
    ).to_formatted_s(:number)
  end

  # Returns the maximum number of national callenges a team can enter taking
  # into account regional customisations.
  def max_national(region)
    region.limit(self)&.max_national_challenges || max_national_challenges
  end

  # Returns the maximum number of regional callenges a team can enter taking
  # into account regional customisations.
  def max_regional(region)
    region.limit(self)&.max_regional_challenges || max_regional_challenges
  end
end
