class Admin::Regions::AssignmentsController < Admin::AssignmentsController
  before_action :authenticate_user!

  def index
    @assignable = @competition.regions.find_by_identifier params[:region_id]
    @competition = @assignable.competition
    handle_index
  end

  def new
    @assignable = @competition.regions.find_by_identifier params[:region_id]
    handle_new
  end

  def create
    @assignable = @competition.regions.find_by_identifier params[:region_id]
    handle_create
  end

  private

  def redirect_to_index
    redirect_to admin_region_assignments_path(@assignable)
  end
end
