class CreateHolders < ActiveRecord::Migration[6.0]
  def down
    remove_column :assignments, :holder_id, :integer

    remove_column :registrations, :holder_id, :integer

    remove_column :favourites, :holder_id, :integer

    drop_table :holders
  end

  def up
    create_table :holders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :competition, null: false, foreign_key: true
      t.boolean :aws_credits_requested

      t.timestamps
    end

    add_index :holders, :aws_credits_requested

    add_column :assignments, :holder_id, :integer
    add_index :assignments, :holder_id

    add_column :registrations, :holder_id, :integer
    add_index :registrations, :holder_id

    add_column :favourites, :holder_id, :integer
    add_index :favourites, :holder_id

    competition_2019 = Competition.find_by_year 2019

    Assignment.all.preload(:user).each do |assignment|
      assignment.update! holder: Holder.find_or_create_by(
        competition_id: assignment.competition_id,
        user_id: assignment.user_id
      ) do |holder|
        return unless competition_2019 == assignment.competition_id

        holder.aws_credits_requested = assignment.user.aws_credits_requested
      end
    end

    Registration.all.preload(assignment: :holder).each do |registration|
      registration.update_attribute 'holder_id', registration.assignment.holder.id
    end

    Favourite.all.preload(assignment: :holder).each do |favourite|
      favourite.update! holder: favourite.assignment.holder
    end
  end
end
