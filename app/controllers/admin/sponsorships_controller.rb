class Admin::SponsorshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    new_sponsorship
    return if params[:term].blank?
    search_sponsors
  end

  def create
    create_new_sponsorship
    if @sponsorship.save
      flash[:notice] = 'New sponsorship created'
      redirect_to admin_region_path(@sponsorable)
    else
      flash.now[:notice] = @sponsorship.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def destroy
    @sponsorship = Sponsorship.find(params[:id])
    @sponsorship.destroy
    flash[:notice] = 'Sponsorship Destroyed'
    redirect_to admin_sponsors_path
  end

  private

  def sponsorship_params
    params.require(:sponsorship).permit(:sponsorship_type_id)
  end

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

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

  def search_sponsors
    @sponsor = Sponsor.find_by_name(params[:term])
    if @sponsor.present?
      @existing_sponsorship = Sponsorship.find_by(sponsor: @sponsor, sponsorable: @sponsorable)
    else
      @sponsors = Sponsor.search(params[:term])
    end
  end
end
