class AddIndexs < ActiveRecord::Migration[5.2]
  def change
    add_index :assignments, :user_id
    add_index :assignments, :title

    add_index :challenge_criteria, :challenge_id
    add_index :challenge_criteria, :criterion_id

    add_index :challenge_data_sets, :challenge_id
    add_index :challenge_data_sets, :data_set_id

    add_index :challenge_judgements, :challenge_criterion_id
    add_index :challenge_judgements, :challenge_scorecard_id

    add_index :challenge_scorecards, :entry_id
    add_index :challenge_scorecards, :assignment_id

    add_index :challenge_sponsorships, :challenge_id
    add_index :challenge_sponsorships, :sponsor_id

    add_index :challenges, :region_id
    add_index :challenges, :competition_id
    add_index :challenges, :approved

    add_index :checkpoints, :competition_id

    add_index :competitions, :year

    add_index :criteria, :competition_id

    add_index :data_sets, :region_id
    add_index :data_sets, :competition_id

    add_index :entries, :team_id
    add_index :entries, :challenge_id
    add_index :entries, :checkpoint_id
    add_index :entries, :eligible

    add_index :event_partnerships, :event_id
    add_index :event_partnerships, :sponsor_id
    add_index :event_partnerships, :approved

    add_index :events, :region_id
    add_index :events, :competition_id
    add_index :events, :approval

    add_index :favourites, :assignment_id
    add_index :favourites, :team_id

    add_index :peoples_judgements, :criterion_id
    add_index :peoples_judgements, :peoples_scorecard_id

    add_index :peoples_scorecards, :team_id
    add_index :peoples_scorecards, :assignment_id

    add_index :projects, :team_id
    add_index :projects, :user_id

    add_index :regions, :parent_id

    add_index :registrations, :assignment_id
    add_index :registrations, :event_id
    add_index :registrations, :status

    add_index :sponsors, :competition_id

    add_index :sponsorship_types, :competition_id
    add_index :sponsorship_types, :order

    add_index :sponsorships, :sponsor_id
    add_index :sponsorships, :approved

    add_index :team_data_sets, :team_id

    add_index :teams, :event_id
    add_index :teams, :project_id
    add_index :teams, :published
  end
end
