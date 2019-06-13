class Admin::CompetitionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_manegement_privileges, except: %i[new create]
  before_action :check_for_admin_privileges, only: %i[new create]

  def index
    @admin_user = current_user.assignments.where(title: ADMIN).any?
  end

  def show
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
      current_user.make_site_admin @competition
      redirect_to admin_competition_path @competition
    else
      flash[:alert] = @competition.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit; end

  def update
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
    params.require(:competition).permit(
      :end_time,
      :start_time,
      :year,
      :peoples_choice_start,
      :peoples_choice_end,
      :challenge_judging_start,
      :challenge_judging_end,
      :current
    )
  end

  def check_for_manegement_privileges
    @competition = nil
    @competition = Competition.find params[:id] if params[:id].present?
    @competitions = Competition.all if @competition.nil?
    return if current_user.admin_privileges?(@competition || @competitions)

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def check_for_admin_privileges
    return if current_user.assignments.where(title: ADMIN).any?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def retrieve_counts
    @regions_count = @competition.regions.count
    @events_count = @competition.events.count
    @challenge_criteria_count = @competition.challenge_criteria.count
    @project_criteria_count = @competition.project_criteria.count
    @teams_count = @competition.teams.count
    sponsor_like_counts
  end

  def sponsor_like_counts
    @sponsors_count = @competition.sponsors.count
    @sponsorship_types_count = @competition.sponsorship_types.count
  end
end
