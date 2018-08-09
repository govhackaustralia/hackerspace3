class Admin::Sponsors::SponsorshipsController < Admin::SponsorshipsController
  private

  def redirect_to_post_destroy_path
    redirect_to admin_sponsor_path(@sponsor)
  end
end
