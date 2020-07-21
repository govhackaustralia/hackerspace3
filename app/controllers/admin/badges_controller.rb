class Admin::BadgesController < ApplicationController
  before_action :authenticate_user!, :authorize_user!

  def index
    @badges = @competition.badges.with_attached_art
  end

  def show
    @badge = @competition.badges.find_by_identifier params[:id]
  end

  def new
    @badge = @competition.badges.new
  end

  def create
    @badge = @competition.badges.new(badge_params)
    if @badge.save
      redirect_to admin_competition_badge_path(@competition, @badge),
        notice: 'New badge created'
    else
      flash[:alert] = @badge.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @badge = Badge.find_by_identifier params[:id]
  end

  def update
    @badge = Badge.find_by_identifier params[:id]
    if @badge.update badge_params
      redirect_to admin_competition_badge_path(@competition, @badge),
        notice: 'badge updated'
    else
      flash[:alert] = @badge.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @badge = Badge.find_by_identifier params[:id]
    @badge.destroy
    if @badge.destroyed?
      redirect_to admin_competition_badges_path, notice: 'Badge deleted'
    else
      flash[:alert] = @badge.errors.full_messages.to_sentence
      render :show
    end
  end

  private

  def badge_params
    params.require(:badge).permit(:name, :capacity, :art)
  end

  def authorize_user!
    return if current_user.admin_privileges? @competition

    redirect_to root_path,
      alert: 'You must have valid assignments to access this section.'
  end
end
