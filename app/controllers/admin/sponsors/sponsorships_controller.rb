class Admin::Sponsors::SponsorshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def destroy
    @sponsorship = Sponsorship.find params[:id]
    @sponsor = @sponsorship.sponsor
    @sponsorship.destroy
    flash[:notice] = 'Sponsorship Destroyed'
    redirect_to admin_sponsor_path @sponsor
  end

  private

  def check_for_privileges
    return if current_user.sponsor_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
