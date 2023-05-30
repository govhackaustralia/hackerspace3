# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :check_competition_started!, :check_team_published!, except: :index
  before_action :authenticate_user!, :check_slack_chat!, only: :slack_chat

  def index
    @projects = @competition.published_projects_by_name
      .preload(:event, :team)
      .includes(:tags)
    @teams = Team.where(id: @projects.pluck(:team_id))
    project_counts
    user_records_index if user_signed_in?
    respond_to do |format|
      format.html
      format.csv { send_data @teams.to_csv @competition }
    end
  end

  def show
    @current_project = @team.current_project
    @passed_checkpoint_ids = @competition.passed_checkpoint_ids @time_zone
    entries_and_users
    user_records_show if user_signed_in?
  end

  def slack_chat
    redirect_to team_slack_chat_service.team_slack_chat_url,
      allow_other_host: true
  end

  private

  def user_records_index
    retrieve_attending_events
    return unless @competition.in_peoples_judging_window? LAST_COMPETITION_TIME_ZONE
    return unless (@peoples_assignment = current_user.peoples_assignment(@competition)).present?

    @judgeable_assignment = current_user.judgeable_assignment @competition
    @project_judging = JudgeableScores.new(@judgeable_assignment, @teams).compile
    @project_judging_total = @competition.score_total PROJECT
  end

  def project_counts
    @challenge_counts = @competition.entries.group(:team_id).count
    @team_data_set_counts = @competition.team_data_sets.group(:team_id).count
  end

  def retrieve_attending_events
    @participating_competition_event = current_user.participating_competition_event @competition
    return unless @participating_competition_event.present?

    @time_zone = @participating_competition_event.region.time_zone
  end

  def user_records_show
    @user = @acting_on_behalf_of_user.presence || current_user
    retrieve_favourite_and_scorecard
    retrieve_slack_chat_stuff
    @judgeable_assignment = @user.judgeable_assignment @competition
    @peoples_assignment = @user.peoples_assignment @competition
    @judge = @user.judge_assignment(@team.challenges)
    @users_team = @user.joined_teams.include? @team
  end

  def retrieve_favourite_and_scorecard
    @favourite = Favourite.find_by(
      assignment: @user.event_assignment(@competition),
      team: @team,
    )
    @header = Header.find_by(
      assignment: @user.event_assignment(@competition),
      scoreable: @team,
    )
  end

  def retrieve_slack_chat_stuff
    @team_can_slack_chat = team_slack_chat_service.can_chat?
    return unless @team.slack_channel_id.present?

    @team_slack_chat_url = team_slack_chat_service.team_slack_chat_url
  end

  def team_slack_chat_service
    @team_slack_chat_service ||= TeamSlackChatService.new(@team)
  end

  def entries_and_users
    @published_users = @team.confirmed_members
      .joins(:profile)
      .where(profiles: {published: true})
      .preload(:profile)
    @unpublished_users = @team.confirmed_members
      .joins(:profile)
      .where(profiles: {published: [nil, false]})
    @entries = @team.entries
      .preload(challenge: %i[sponsors_with_logos published_entries])
  end

  def check_competition_started!
    @team = Project.find_by(identifier: params[:identifier]).team
    @time_zone = @team.region.time_zone
    return if @competition.started? @time_zone

    redirect_to projects_path,
      alert: 'Teams will become visible at the start of the competition'
  end

  def check_team_published!
    return if @team.published

    redirect_to projects_path,
      alert: 'This Team Project has not been published'
  end

  def check_slack_chat!
    return if team_slack_chat_service.can_chat? && user_signed_in? && profile.slack_user_id

    redirect_to projects_path,
      alert: 'Unable to slack chat with this team'
  end
end
