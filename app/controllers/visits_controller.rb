# frozen_string_literal: true

class VisitsController < ApplicationController
  def index
    visit = Visit.create(visit_params)
    if visit.visitable.url.present?
      redirect_to visit.visitable.url, allow_other_host: true
    else
      redirect_to root_path, alert: 'No URL to navigate to 😬'
    end
  end

  private

  def visit_params
    params.require(:visit).permit(:visitable_type, :visitable_id)
      .merge(user: current_user, competition: competition)
  end
end
