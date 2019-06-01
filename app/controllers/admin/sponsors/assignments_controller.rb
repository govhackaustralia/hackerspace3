class Admin::Sponsors::AssignmentsController < Admin::AssignmentsController
  before_action :authenticate_user!

  def new
    @assignable = Sponsor.find params[:sponsor_id]
    handle_new
  end

  def create
    @assignable = Sponsor.find params[:sponsor_id]
    handle_create
  end

  private

  def redirect_to_index
    redirect_to admin_competition_sponsor_path(
      @assignable.competition, @assignable
    )
  end
end
