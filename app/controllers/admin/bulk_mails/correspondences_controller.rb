class Admin::BulkMails::CorrespondencesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def show
    @correspondence = Correspondence.find(params[:id])
    @bulk_mail = @correspondence.bulk_mail
    @user = @correspondence.user
    @region = @bulk_mail.region
  end

  private

  def check_for_privileges
    return if current_user.region_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
