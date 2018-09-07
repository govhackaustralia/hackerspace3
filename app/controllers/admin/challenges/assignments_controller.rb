class Admin::Challenges::AssignmentsController < Admin::AssignmentsController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def new
    @assignable = Challenge.find(params[:challenge_id])
    handle_new
  end

  def create
    @assignable = Challenge.find(params[:challenge_id])
    handle_create
  end

  private

  def redirect_to_index
    redirect_to admin_region_challenge_path(@assignable.region, @assignable)
  end

  def check_for_privileges
    return if current_user.region_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
