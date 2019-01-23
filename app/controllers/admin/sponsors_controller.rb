class Admin::SponsorsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @competition = Competition.current
    @sponsors = @competition.sponsors
  end

  def show
    @sponsor = Sponsor.find(params[:id])
  end

  def new
    @sponsor = Sponsor.new
  end

  def create
    @sponsor = Competition.current.sponsors.create(sponsor_params)
    if @sponsor.save
      flash[:notice] = 'New Sponsor Created'
      redirect_to admin_sponsor_path @sponsor
    else
      flash[:alert] = @sponsor.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @sponsor = Sponsor.find(params[:id])
  end

  def update
    @sponsor = Sponsor.find(params[:id])
    @sponsor.update(sponsor_params) if params[:sponsor].present?
    handle_update
  end

  def destroy
    @sponsor = Sponsor.find(params[:id])
    @sponsor.destroy
    flash[:notice] = 'Sponsor Destroyed'
    redirect_to admin_sponsors_path
  end

  private

  def sponsor_params
    params.require(:sponsor).permit(:name, :description, :logo, :website)
  end

  def check_for_privileges
    return if current_user.sponsor_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def handle_update
    if @sponsor.save
      handle_update_success
    else
      flash[:alert] = @sponsor.errors.full_messages.to_sentence
      render :edit
    end
  end

  # ENHANCEMENT: Break this up into separate controllers.
  def handle_update_success
    if params[:logo].present?
      flash[:notice] = 'Logo Uploaded'
      render :edit, logo: true
    else
      flash[:notice] = 'Sponsor Updated'
      redirect_to admin_sponsor_path @sponsor
    end
  end
end
