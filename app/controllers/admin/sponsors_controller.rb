class Admin::SponsorsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @sponsors = @competition.sponsors.preload(:sponsorships, :event_partnerships, :challenge_sponsorships)
    @admin_privileges = current_user.admin_privileges? @competition
  end

  def show
    @sponsor = Sponsor.find params[:id]
  end

  def new
    @sponsor = Sponsor.new
  end

  def create
    @sponsor = @competition.sponsors.new sponsor_params
    if @sponsor.save
      flash[:notice] = 'New Sponsor Created'
      redirect_to admin_competition_sponsor_path @competition, @sponsor
    else
      flash[:alert] = @sponsor.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @sponsor = Sponsor.find params[:id]
  end

  def update
    @sponsor = Sponsor.find params[:id]
    if @sponsor.update sponsor_params
      flash[:notice] = 'Sponsor Updated'
      redirect_to admin_competition_sponsor_path @competition, @sponsor
    else
      flash[:alert] = @sponsor.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @sponsor = Sponsor.find(params[:id])
    @sponsor.destroy
    flash[:notice] = 'Sponsor Destroyed'
    redirect_to admin_competition_sponsors_path @competition
  end

  private

  def sponsor_params
    params.require(:sponsor).permit :name, :description, :url
  end

  def check_for_privileges
    @competition = Competition.find params[:competition_id]
    return if current_user.sponsor_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
