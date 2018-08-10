class Admin::SponsorshipTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @competition = Competition.current
    @sponsorship_types = @competition.sponsorship_types.order(order: :asc)
  end

  def new
    @competition = Competition.current
    @sponsorship_type = @competition.sponsorship_types.new
  end

  def edit
    @sponsorship_type = SponsorshipType.find params[:id]
  end

  def create
    create_new_sponsorship_type
    if @sponsorship_type.save
      flash[:notice] = 'New Sponsorship Type Created'
      redirect_to admin_sponsorship_types_path
    else
      flash[:alert] = 'Could not save sponsorship type'
      render :new
    end
  end

  def update
    SponsorshipType.reorder_from(params[:sponsorship_type][:order].to_i)
    @sponsorship_type = SponsorshipType.find(params[:id])
    if @sponsorship_type.update(sponsorship_type_params)
      flash[:notice] = 'Sponsorship Type Updated'
      redirect_to admin_sponsorship_types_path
    else
      flash[:alert] = @sponsorship_type.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def sponsorship_type_params
    params.require(:sponsorship_type).permit(:name, :order)
  end

  def check_for_privileges
    return if current_user.sponsor_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def create_new_sponsorship_type
    SponsorshipType.reorder_from(params[:sponsorship_type][:order].to_i)
    @sponsorship_type = Competition.current.sponsorship_types.new(sponsorship_type_params)
  end
end
