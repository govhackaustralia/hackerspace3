class VisitsController < ApplicationController
  def index
    visit = Visit.create(visit_params)
    redirect_to visit.visitable.url
  end

  private

  def visit_params
    params.require(:visit).permit(:visitable_type, :visitable_id)
      .merge(user: current_user, competition: competition)
  end
end
