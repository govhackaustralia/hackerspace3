class Admin::Sponsors::SponsorshipsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def destroy
    @sponsorship = Sponsorship.find params[:id]
    @sponsor = @sponsorship.sponsor
    @sponsorship.destroy
    flash[:notice] = 'Sponsorship Destroyed'
    redirect_to admin_competition_sponsor_path @competition, @sponsor
  end

  private

  def check_for_privileges
    @sponsor = Sponsor.find params[:sponsor_id]
    @competition = @sponsor.competition
    return if current_user.sponsor_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
