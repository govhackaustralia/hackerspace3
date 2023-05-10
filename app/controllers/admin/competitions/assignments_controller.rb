# frozen_string_literal: true

class Admin::Competitions::AssignmentsController < Admin::AssignmentsController
  before_action :authenticate_user!

  def index
    @assignable = Competition.find(params[:competition_id])
    handle_index
  end

  def new
    @assignable = Competition.find(params[:competition_id])
    handle_new
  end

  def create
    @assignable = Competition.find(params[:competition_id])
    handle_create
  end

  private

  def redirect_to_index
    redirect_to admin_competition_assignments_path(@assignable)
  end
end
