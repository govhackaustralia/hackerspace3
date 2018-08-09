class Admin::Challenges::SponsorshipsController < Admin::SponsorshipsController
  private

  def new_sponsorship
    @sponsorable = Challenge.find(params[:challenge_id])
    @sponsorship = Sponsorship.new
  end

  def create_new_sponsorship
    @sponsorable = Challenge.find(params[:challenge_id])
    @sponsor = Sponsor.find(params[:sponsor_id])
    @sponsorship = @sponsorable.sponsorships.new(sponsorship_params)
    @sponsorship.update(sponsor: @sponsor)
  end

  def redirect_to_sponsorable
    redirect_to admin_region_challenge_path(@sponsorable.region, @sponsorable)
  end

  def redirect_to_post_destroy_path
    redirect_to_sponsorable
  end
end
