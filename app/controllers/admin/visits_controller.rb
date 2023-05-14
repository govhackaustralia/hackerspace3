# frozen_string_literal: true

class Admin::VisitsController < ApplicationController
  before_action :authenticate_user!, :authorize_user!

  def index
    @visit_counts = @competition.visits.group(:visitable_type, :visitable_id).count
    @visits = @competition.visits.preload(:visitable)
  end

  private

  def authorize_user!
    return if current_user.admin_privileges? @competition

    redirect_to root_path,
      alert: 'You must have valid assignments to access this section.'
  end
end
