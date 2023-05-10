# frozen_string_literal: true

class Admin::ResourcesController < ApplicationController
  before_action :authenticate_user!, :authorise_user!

  def index
    @resources = @competition.resources.order position: :asc
  end

  def new
    @resource = @competition.resources.new
  end

  def create
    @resource = @competition.resources.new(resource_params)
    if @resource.save
      redirect_to admin_competition_resources_path(@competition),
        notice: 'New Resource Created'
    else
      flash[:alert] = @resource.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @resource = Resource.find params[:id]
  end

  def update
    @resource = Resource.find params[:id]
    if @resource.update resource_params
      redirect_to admin_competition_resources_path(@competition),
        notice: 'Resource Updated'
    else
      flash[:alert] = @resource.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @resource = Resource.find params[:id]
    @resource.destroy
    redirect_to admin_competition_resources_path(@competition),
      notice: 'Resource Destroyed'
  end

  private

  def resource_params
    params.require(:resource)
      .permit(:name, :position, :category, :url, :short_url, :show_on_front_page)
  end

  def authorise_user!
    return if current_user.admin_privileges? @competition

    redirect_to root_path,
      alert: 'You must have valid assignments to access this section.'
  end
end
