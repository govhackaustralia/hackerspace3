# frozen_string_literal: true

# == Schema Information
#
# Table name: competitions
#
#  id                      :bigint           not null, primary key
#  challenge_judging_end   :datetime
#  challenge_judging_start :datetime
#  current                 :boolean
#  end_time                :datetime
#  hunt_published          :boolean
#  peoples_choice_end      :datetime
#  peoples_choice_start    :datetime
#  start_time              :datetime
#  team_form_end           :datetime
#  team_form_start         :datetime
#  year                    :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  hunt_badge_id           :integer
#
# Indexes
#
#  index_competitions_on_current  (current)
#  index_competitions_on_year     (year)
#
FactoryBot.define do
  factory :competition do
    year { 2020 }
    team_form_start { '2020-01-01 00:00:00' }
    team_form_end { '2020-02-01 00:00:00' }
    start_time { '2020-03-01 00:00:00' }
    end_time { '2020-04-01 00:00:00' }
    challenge_judging_start { '2020-05-01 00:00:00' }
    challenge_judging_end { '2020-06-01 00:00:00' }
    peoples_choice_start { '2020-05-01 00:00:00' }
    peoples_choice_end { '2020-06-01 00:00:00' }
  end
end
