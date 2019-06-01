class Admin::SponsorshipTypesController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index
    @sponsorship_types = @competition.sponsorship_types.order order: :asc
    @admin_privileges = current_user.admin_privileges? @competition
  end

  def new
    @sponsorship_type = @competition.sponsorship_types.new
  end

  def create
    create_new_sponsorship_type
    if @sponsorship_type.save
      flash[:notice] = 'New Sponsorship Type Created'
      redirect_to admin_competition_sponsorship_types_path @competition
    else
      flash[:alert] = 'Could not save sponsorship type'
      render :new
    end
  end

  def edit
    @sponsorship_type = SponsorshipType.find params[:id]
  end

  def update
    update_sponsorship_type
    if @sponsorship_type.update sponsorship_type_params
      flash[:notice] = 'Sponsorship Type Updated'
      redirect_to admin_competition_sponsorship_types_path @competition
    else
      flash[:alert] = @sponsorship_type.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def sponsorship_type_params
    params.require(:sponsorship_type).permit :name, :order
  end

  def check_for_privileges
    @competition = Competition.find params[:competition_id]
    return if current_user.sponsor_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def create_new_sponsorship_type
    SponsorshipType.reorder_from params[:sponsorship_type][:order].to_i
    @sponsorship_type = @competition.sponsorship_types.new(
      sponsorship_type_params
    )
  end

  def update_sponsorship_type
    SponsorshipType.reorder_from params[:sponsorship_type][:order].to_i
    @sponsorship_type = SponsorshipType.find params[:id]
  end
end
