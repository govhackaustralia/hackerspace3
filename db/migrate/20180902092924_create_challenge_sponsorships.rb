class CreateChallengeSponsorships < ActiveRecord::Migration[5.2]
  def change
    create_table :challenge_sponsorships do |t|
      t.integer :challenge_id
      t.integer :sponsor_id

      t.timestamps
    end
  end
end
