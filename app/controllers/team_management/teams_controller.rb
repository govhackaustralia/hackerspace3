class TeamManagement::TeamsController < ApplicationController
  before_action :authenticate_user!, :authorise_user!
  before_action :check_in_form_or_comp_window!, only: %i[
    show
    edit
    update
  ]
  before_action :check_in_comp_window!, only: %i[
    edit_thumbnail
    update_thumbnail
    edit_image
    update_image
  ]

  def show
    @published_users = @team.confirmed_members.joins(:profile).where(profiles: {published: true}).preload(:profile)
    @current_project = @team.current_project
    @event = @team.event
    @region = @event.region
  end

  def edit
    @events = @team.member_competition_events
  end

  def update
    @events = @team.member_competition_events
    @team.update team_params
    if @team.save
      flash[:notice] = 'Team Details Updated'
      redirect_to team_management_team_path @team
    else
      flash[:alert] = @team.errors.full_messages.to_sentence
      render :edit
    end
  end

  def edit_thumbnail; end

  def update_thumbnail
    @team.update(team_params) unless params[:team].blank?
    if @team.save
      flash[:notice] = 'Thumbnail Updated'
    else
      flash[:alert] = @team.errors.full_messages.to_sentence
    end
    redirect_to action: :edit_thumbnail
  end

  def edit_image; end

  def update_image
    @team.update(team_params) unless params[:team].blank?
    if @team.save
      flash[:notice] = 'High Resolution Image Updated'
    else
      flash[:alert] = @team.errors.full_messages.to_sentence
    end
    redirect_to action: :edit_image
  end

  private

  def team_params
    params.require(:team).permit(
      :event_id,
      :thumbnail,
      :high_res_image,
      :youth_team
    )
  end

  def authorise_user!
    @team = Team.find params[:team_id] || params[:id]
    @time_zone = @team.time_zone
    @competition = @team.competition
    return if @team.permission? current_user

    flash[:alert] = 'You do not have access permissions for this team.'
    redirect_to root_path
  end

  def check_in_comp_window!
    return if @competition.in_comp_window? @time_zone

    alert_and_redirect_out
  end

  def check_in_form_or_comp_window!
    return if @competition.in_form_or_comp_window? @time_zone

    alert_and_redirect_out
  end

  def alert_and_redirect_out
    flash[:alert] = 'No team editing at this time.'
    if @team.published?
      redirect_to project_path @team.current_project.identifier
    else
      redirect_to projects_path
    end
  end
end
