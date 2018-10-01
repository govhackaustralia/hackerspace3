class Admin::Regions::BulkMailsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @region = Region.find(params[:region_id])
    @bulk_mails = @region.bulk_mails
  end

  def show
    @bulk_mail = BulkMail.find(params[:id])
    @mail_orders = @bulk_mail.mail_orders
    @region = @bulk_mail.region
    @teams = @region.teams
    @id_team_projects = Team.id_teams_projects(@teams)
    @id_team_participants = Team.id_team_participants(@teams)
  end

  def new
    @region = Region.find(params[:region_id])
    @bulk_mail = @region.bulk_mails.new
  end

  def edit
    @bulk_mail = BulkMail.find(params[:id])
    @region = @bulk_mail.region
    @mail_orders = @bulk_mail.mail_orders
    @teams = @region.teams
    @id_team_projects = Team.id_teams_projects(@teams)
  end

  def create
    @region = Region.find(params[:region_id])
    @bulk_mail = @region.bulk_mails.new(bulk_mail_params)
    @bulk_mail.user = current_user
    if @bulk_mail.save
      @bulk_mail.create_mail_orders
      flash[:notice] = 'New Bulk Mail Order Created'
      redirect_to admin_region_bulk_mail_path(@region, @bulk_mail)
    else
      flash[:alert] = @bulk_mail.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    @bulk_mail = BulkMail.find(params[:id])
    @region = @bulk_mail.region
    @mail_orders = @bulk_mail.mail_orders
    process_mail_orders unless params[:mail_orders].nil?
    @bulk_mail.update(bulk_mail_params) unless params[:bulk_mail].nil?
    if @bulk_mail.save
      flash[:notice] = 'Bulk Mail Updated'
      redirect_to admin_region_bulk_mail_path(@region, @bulk_mail)
    else
      flash[:alert] = @bulk_mail.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def bulk_mail_params
    params.require(:bulk_mail).permit(:name)
  end

  def process_mail_orders
    @mail_orders.each do |mail_order|
      new_type = params[:mail_orders][mail_order.id.to_s][:request_type]
      mail_order.update(request_type: new_type)
    end
  end

  def check_for_privileges
    return if current_user.region_privileges?
    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
