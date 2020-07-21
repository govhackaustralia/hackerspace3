class ClaimsController < ApplicationController
  before_action :authenticate_user!, :badge

  def new; end

  def create
    if claim.save
      redirect_to profile_path(profile),
        notice: "#{badge.name} Added"
    else
      flash[:alert] = @claim.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def badge
    @badge = @competition.badges.find_by_identifier params[:badge_id]
  end

  def claim
    @claim ||= current_user.assignments.create(
      title: ASSIGNEE,
      assignable: @badge,
      holder: @holder
    )
  end
end
