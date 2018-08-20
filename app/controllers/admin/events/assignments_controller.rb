class Admin::Events::AssignmentsController < Admin::AssignmentsController
  before_action :authenticate_user!

  def index
    @assignable = Event.find(params[:event_id])
    handle_index
  end

  def new
    @assignable = Event.find(params[:event_id])
    handle_new
  end

  def create
    @assignable = Event.find(params[:event_id])
    handle_create
  end

  private

  def redirect_to_index
    redirect_to admin_event_assignments_path(@assignable)
  end
end
