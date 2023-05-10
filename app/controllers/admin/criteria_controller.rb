# frozen_string_literal: true

class Admin::CriteriaController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def index; end

  def new
    @criterion = @competition.criteria.new
  end

  def create
    @criterion = @competition.criteria.new criterion_params
    if @criterion.save
      flash[:notice] = 'Criterion created.'
      redirect_to admin_competition_criteria_path @competition
    else
      flash[:alert] = @criterion.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @criterion = Criterion.find params[:id]
  end

  def update
    @criterion = Criterion.find params[:id]
    if @criterion.update criterion_params
      flash[:notice] = 'Criterion updated.'
      redirect_to admin_competition_criteria_path @competition
    else
      flash[:alert] = @criterion.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def check_for_privileges
    @competition = Competition.find params[:competition_id]
    return if current_user.criterion_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def criterion_params
    params.require(:criterion).permit :category, :name, :description
  end
end
