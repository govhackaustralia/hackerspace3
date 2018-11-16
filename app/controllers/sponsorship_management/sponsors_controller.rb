class SponsorshipManagement::SponsorsController < ApplicationController
  before_action :authenticate_user!

  def show
    @sponsor = Sponsor.find(params[:id])
    return if @sponsor.show_privileges?(current_user)

    redirect_no_privileges
  end

  def edit
    @sponsor = Sponsor.find(params[:id])
    return if @sponsor.show_privileges?(current_user)

    redirect_no_privileges
  end

  def update
    @sponsor = Sponsor.find(params[:id])
    if @sponsor.show_privileges?(current_user) == false
      redirect_no_privileges
    else
      handle_update
    end
  end

  private

  def sponsor_params
    params.require(:sponsor).permit(:name, :description, :logo)
  end

  def redirect_no_privileges
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def handle_update
    @sponsor.update(sponsor_params) unless params[:sponsor].nil?
    if @sponsor.save
      handle_update_success
    else
      handle_update_fail
    end
  end

  def handle_update_success
    if params[:logo]
      flash[:notice] = 'Sponsor Logo Updated'
      render :edit, logo: true
    else
      flash[:notice] = 'Sponsor Updated'
      redirect_to sponsorship_management_sponsor_path(@sponsor)
    end
  end

  def handle_update_fail
    flash[:alert] = @sponsor.errors.full_messages.to_sentence
    render :edit
  end
end
