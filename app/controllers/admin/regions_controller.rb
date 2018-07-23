class Admin::RegionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index; end

  def create
    region = Region.create(name: params[:name],
                           time_zone: params[:time_zone],
                           parent_id: params[:parent_id])
    flash[:notice] = if region.persisted?
                       "New region '#{region.name}' added."
                     else
                       region.errors.full_messages.to_sentence
                     end
    redirect_to admin_regions_path
  end

  private

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
