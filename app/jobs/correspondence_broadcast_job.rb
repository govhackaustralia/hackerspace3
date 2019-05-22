class CorrespondenceBroadcastJob < ApplicationJob
  queue_as :default

  def perform(correspondence)
    ActionCable.server.broadcast(
      "bulk_mails_#{correspondence.bulk_mail.id}_channel",
      correspondence: render_correspondence_link(correspondence),
      user_id: correspondence.user_id
    )
  end

  private

  def render_correspondence_link(correspondence)
    Admin::Regions::BulkMailsController.render(
      partial: 'correspondence_link',
      locals: { correspondence: correspondence }
    )
  end
end
