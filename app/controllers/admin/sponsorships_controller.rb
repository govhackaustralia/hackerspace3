class Admin::SponsorshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    sponsorable
    @sponsorship = Sponsorship.new
  end

  def create
    sponsorable
    @sponsorship = @sponsorable.sponsorships.new(sponsorship_params)
    if @sponsorship.save
      flash[:notice] = 'New sponsorship created'
      redirect_successful_create
    else
      flash[:notice] = 'Could not save sponsorship'
      render_unsuccessful_create
    end
  end

  private

  def sponsorship_params
    params.require(:sponsorship).permit(:sponsorship_type_id, :sponsor_id)
  end

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def sponsorable
    @sponsorable = Event.find_by_id(params[:event_id])
    @sponsorable ||= Region.find_by_id(params[:region_id])
  end

  def redirect_successful_create
    if @sponsorable.class == Region
      redirect_to admin_region_path(@sponsorable)
    else
      redirect_to admin_region_event_path(@sponsorable.region, @sponsorable)
    end
  end

  def render_unsuccessful_create
    if @sponsorable.class == Region
      redirect_to new_admin_region_sponsorship_path(@sponsorable)
    else
      redirect_to new_admin_event_sponsorship_path(@sponsorable)
    end
  end
end
