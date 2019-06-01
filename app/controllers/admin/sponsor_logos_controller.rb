class Admin::SponsorLogosController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def edit; end

  def update
    if params[:sponsor].present?
      update_logo
    else
      flash[:alert] = 'Please select a file to upload'
    end
    render :edit
  end

  private

  def sponsor_params
    params.require(:sponsor).permit :logo
  end

  def check_for_privileges
    @sponsor = Sponsor.find params[:id]
    return if current_user.sponsor_privileges? @sponsor.competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def update_logo
    if @sponsor.update sponsor_params
      flash[:notice] = 'Logo Updated'
    else
      flash[:alert] = @sponsor.errors.full_messages.to_sentence
    end
  end
end
