class Admin::RegionsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @region = Region.root
  end

  def new
    @region = Region.new if @region.nil?
  end

  def create
    create_new_region
    if @region.save
      flash[:notice] = "New Region '#{@region.name}' added."
      redirect_to admin_regions_path
    else
      flash.now[:notice] = @region.errors.full_messages.to_sentence
      render 'new'
    end
  end

  def show
    @region = Region.find(params[:id])
  end

  private

  def region_params
    params.require(:region).permit(:time_zone, :name)
  end

  def check_for_privileges
    return if current_user.admin_privileges?
    flash[:error] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def create_new_region
    @region = Region.new(region_params)
    @region.update(parent_id: Region.root.id)
  end
end
