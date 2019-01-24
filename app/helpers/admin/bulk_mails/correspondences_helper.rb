module Admin::BulkMails::CorrespondencesHelper
  def correspondence_with(user_id)
    @correspondences.detect { |c| c.user_id == user_id }
  end
end
