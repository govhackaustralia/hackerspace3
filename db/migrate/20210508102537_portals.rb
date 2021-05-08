class Portals < ActiveRecord::Migration[6.1]
  def change
    RegionDataset.all.each do |region_dataset|
      Portal.create!(
        portable_type: 'Region',
        portable_id: region_dataset.region_id,
        dataset_id: region_dataset.dataset_id
      )
    end

    ChallengeDataset.all.each do |challenge_dataset|
      Portal.create!(
        portable_type: 'Challenge',
        portable_id: challenge_dataset.challenge_id,
        dataset_id: challenge_dataset.dataset_id
      )
    end

    TeamDataset.all.each do |team_dataset|
      portal = Portal.create!(
        portable_type: 'Team',
        portable_id: team_dataset.team_id,
        dataset_id: team_dataset.dataset_id
      )
      Extra.create! portal: portal, entry: team_dataset.description_of_use
    end
  end
end
