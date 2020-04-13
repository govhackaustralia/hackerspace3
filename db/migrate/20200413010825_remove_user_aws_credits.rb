class RemoveUserAwsCredits < ActiveRecord::Migration[6.0]
  def up
    Competition.all.each do |competition|
      competition.competition_registrations
        .preload(:user, :holder).each do |registration|
          next if registration.user.aws_credits_requested ==
            registration.holder.aws_credits_requested

          raise "Difference in holder: #{registration.holder.id}"
        end
    end

    remove_column :users, :aws_credits_requested, :boolean
  end
end
