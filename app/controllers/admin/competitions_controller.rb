class Admin::CompetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @competitions = Competition.all
  end

  def show
    @competition = Competition.find params[:id]
    @director = @competition.director
    @site_admins = @competition.site_admins
    @management_team = @competition.management_team
    @checkpoints = @competition.checkpoints
    retrieve_counts
  end

  def new
    @competition = Competition.new
  end

  def create
    @competition = Competition.new competition_params
    if @competition.save
      flash[:notice] = 'New competition created.'
      redirect_to admin_competition_path @competition
    else
      flash[:alert] = @competition.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @competition = Competition.find params[:id]
  end

  def update
    @competition = Competition.find params[:id]
    if @competition.update competition_params
      flash[:notice] = 'Competition Times update.'
      redirect_to admin_competition_path @competition
    else
      flash[:alert] = @competition.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def competition_params
    params.require(:competition).permit :end_time, :start_time, :year,
                                        :peoples_choice_start,
                                        :peoples_choice_end,
                                        :challenge_judging_start,
                                        :challenge_judging_end, :current
  end

  def check_for_privileges
    return if current_user.admin_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def retrieve_counts
    @regions_count = @competition.regions.count
    @challenge_criteria_count = @competition.challenge_criteria.count
    @project_criteria_count = @competition.project_criteria.count
  end
end
