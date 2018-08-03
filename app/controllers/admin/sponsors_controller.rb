class Admin::SponsorsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @competition = Competition.current
    @sponsors = @competition.sponsors
  end

  def new
    @sponsor = Sponsor.new
  end

  def create
    @sponsor = Competition.current.sponsors.create(sponsor_params)
    if @sponsor.save
      flash[:notice] = 'New Sponsor Created'
      redirect_to admin_sponsors_path
    else
      flash[:notice] = 'Could not save sponsor'
      render new_admin_sponsor_path(@sponsor)
    end
  end

  def destroy
    @sponsor = Sponsor.find(params[:id])
    @sponsor.destroy
    flash[:notice] = 'Sponsor Destroyed'
    redirect_to admin_sponsors_path
  end

  private

  def sponsor_params
    params.require(:sponsor).permit(:name, :description, :logo)
  end

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
