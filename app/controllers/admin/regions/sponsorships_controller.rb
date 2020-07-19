class Admin::Regions::SponsorshipsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @sponsorships = @region.sponsorships
  end

  def new
    @sponsorable = @region
    @sponsorship = Sponsorship.new
    search_sponsors unless params[:term].blank?
  end

  def create
    create_new_sponsorship
    if @sponsorship.save
      flash[:notice] = 'New sponsorship created'
      redirect_to admin_region_sponsorships_path @sponsorable
    else
      flash.now[:alert] = @sponsorship.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def sponsorship_params
    params.require(:sponsorship).permit :sponsorship_type_id, :sponsor_id
  end

  def create_new_sponsorship
    @sponsorable = @region
    @sponsorship = @sponsorable.sponsorships.new sponsorship_params
  end

  def check_for_privileges
    @region = @competition.regions.find_by_identifier params[:region_id]
    @competition = @region.competition
    return if current_user.sponsor_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def search_sponsors
    @sponsor = @competition.sponsors.find_by_name params[:term]
    if @sponsor.present?
      @existing_sponsorship = Sponsorship.find_by(
        sponsor: @sponsor,
        sponsorable: @sponsorable
      )
    else
      @sponsors = @competition.sponsors.search params[:term]
    end
  end
end
