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
      redirect_to_sponsorable
    else
      flash.now[:notice] = @sponsorship.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def destroy
    @sponsorship = Sponsorship.find(params[:id])
    @sponsor = @sponsorship.sponsor
    @sponsorship.destroy
    flash[:notice] = 'Sponsorship Destroyed'
    redirect_to_post_destroy_path
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

  def search_sponsors
    @sponsor = Sponsor.find_by_name(params[:term])
    if @sponsor.present?
      @existing_sponsorship = Sponsorship.find_by(sponsor: @sponsor, sponsorable: @sponsorable)
    else
      @sponsors = Sponsor.search(params[:term])
    end
  end
end
