class Admin::Regions::SponsorshipsController < Admin::SponsorshipsController
  def index
    @region = Region.find(params[:region_id])
    @sponsorships = @region.sponsorships
  end

  private

  def new_sponsorship
    @sponsorable = Region.find(params[:region_id])
    @sponsorship = Sponsorship.new
  end

  def create_new_sponsorship
    @sponsorable = Region.find(params[:region_id])
    @sponsor = Sponsor.find(params[:sponsor_id])
    @sponsorship = @sponsorable.sponsorships.new(sponsorship_params)
    @sponsorship.update(sponsor: @sponsor)
  end

  def redirect_to_sponsorable
    redirect_to admin_region_sponsorships_path(@sponsorable)
  end

  def redirect_to_post_destroy_path
    redirect_to_sponsorable
  end
end
