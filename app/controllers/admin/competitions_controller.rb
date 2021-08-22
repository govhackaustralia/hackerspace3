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
      post_create_tasks
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

  def aws_credits_requested
    @report = AwsCreditsRequestedReport.new @competition
    @regions = @competition.regions.preload :events
  end

  def sponsor_data_set_report
    sponsor_data_set = SponsorDataSetReport.new(@competition)
    respond_to do |format|
      format.html do
        @report = sponsor_data_set.report
        @unaccounted_team_data_set_count = sponsor_data_set.unaccounted_team_data_set_count
      end
      format.csv { send_data sponsor_data_set.to_csv }
    end
  end

  def demographics_report
    field = params[:field]
    demographics_report = DemographicsReport.new(@competition, field)

    respond_to do |format|
      format.html do
        @report = demographics_report.report
        @field = field.capitalize
      end
      format.csv { send_data demographics_report.to_csv }
    end
  end

  private

  def competition_params
    params.require(:competition).permit(
      :year,
      :team_form_start, :team_form_end,
      :end_time, :start_time,
      :peoples_choice_start, :peoples_choice_end,
      :challenge_judging_start, :challenge_judging_end,
      :current
    )
  end

  def check_for_manegement_privileges
    @competition = nil
    @competition = Competition.find params[:id] if params[:id].present?
    @competitions = Competition.all.order(:year) if @competition.nil?
    return if current_user.admin_privileges?(@competition || @competitions)

    redirect_invalid_assignments
  end

  def check_for_admin_privileges
    return if current_user.assignments.where(title: ADMIN).any?

    redirect_invalid_assignments
  end

  def redirect_invalid_assignments
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def retrieve_counts
    @regions_count = @competition.regions.count
    @challenge_criteria_count = @competition.challenge_criteria.count
    @teams_count = @competition.teams.count
    event_and_registration_counts
    competition_entity_counts
    resource_counts
    sponsoresk_counts
  end

  def event_and_registration_counts
    @events_count = @competition.events.count
    @attending_connection_registrations_count =
      @competition.connection_registrations.attending.count
    @attending_conference_registrations_count =
      @competition.conference_registrations.attending.count
    @attending_competition_registrations_count =
      @competition.competition_registrations.attending.count
    @attending_award_registrations_count =
      @competition.award_registrations.attending.count
  end

  def competition_entity_counts
    @project_criteria_count = @competition.project_criteria.count
    @badge_count = @competition.badges.count
    @hunt_question_count = @competition.hunt_questions.count
    @data_portals_count = @competition.resources.data_portal.count
  end

  def resource_counts
    @tech_count = @competition.resources.tech.count
    @information_count = @competition.resources.information.count
    @visitable_counts = @competition.visits.group(:visitable_type).count
  end

  def sponsoresk_counts
    @sponsors_count = @competition.sponsors.count
    @sponsorship_types_count = @competition.sponsorship_types.count
    @credits_count = @competition.competition_registrations.aws_credits_requested.count
  end

  def post_create_tasks
    @competition.regions.internationals.create(
      name: Region::INTERNATIONAL,
      category: Region::INTERNATIONAL
    )
    current_user.make_site_admin @competition
  end
end
