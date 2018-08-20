class Admin::Challenges::AssignmentsController < Admin::AssignmentsController
  before_action :authenticate_user!

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
end
