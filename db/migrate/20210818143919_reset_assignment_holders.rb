class ResetAssignmentHolders < ActiveRecord::Migration[6.1]
  def change
    Assignment.all.each do |assignment|
      holder = Holder.find_or_create_by(
        user_id: assignment.user_id,
        competition_id: assignment.competition_id
      )
      next if holder.id == assignment.holder_id

      assignment.update! holder: holder
    end
  end
end
