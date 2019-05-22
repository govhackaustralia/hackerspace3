class Admin::Regions::BulkMailsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges

  def index
    @region = Region.find params[:region_id]
    @bulk_mails = @region.bulk_mails
    @competition = @region.competition
  end

  def show
    @bulk_mail = BulkMail.find params[:id]
    @team_orders = @bulk_mail.team_orders.preload(team: %i[current_project leaders members])
    @region = @bulk_mail.mailable
    @bulk_mail.update_team_orders
    retrieve_team_helpers
  end

  def new
    @region = Region.find params[:region_id]
    @bulk_mail = @region.bulk_mails.new
  end

  def create
    @region = Region.find params[:region_id]
    @bulk_mail = @region.bulk_mails.new(bulk_mail_params)
    @bulk_mail.user = current_user
    @bulk_mail.status = DRAFT
    handle_create
  end

  def edit
    @bulk_mail = BulkMail.find params[:id]
    @region = @bulk_mail.mailable
    @team_orders = @bulk_mail.team_orders.preload(team: %i[current_project leaders members])
    @bulk_mail.update_team_orders
  end

  def update
    @bulk_mail = BulkMail.find params[:id]
    @region = @bulk_mail.mailable
    perform_update_operations
    handle_update
  end

  private

  def bulk_mail_params
    params.require(:bulk_mail).permit(:name, :from_email, :subject, :body)
  end

  def update_team_orders
    @team_orders.each do |team_order|
      new_type = params[:team_orders][team_order.id.to_s][:request_type]
      team_order.update request_type: new_type
    end
  end

  def check_for_privileges
    return if current_user.region_privileges?

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def perform_update_operations
    @team_orders = @bulk_mail.team_orders
    update_team_orders unless params[:team_orders].nil?
    @bulk_mail.update(bulk_mail_params) unless params[:bulk_mail].nil?
  end

  def retrieve_team_helpers
    @participant_count = 0
    @example_user = User.first
    @example_project = Project.first
    @correspondences = @bulk_mail.correspondences
  end

  def handle_create
    if @bulk_mail.save
      @bulk_mail.create_team_orders
      flash[:notice] = 'New Bulk Mail Order Created'
      redirect_to admin_region_bulk_mail_path(@region, @bulk_mail)
    else
      flash[:alert] = @bulk_mail.errors.full_messages.to_sentence
      render :new
    end
  end

  def handle_update
    if @bulk_mail.save
      flash[:notice] = 'Bulk Mail Updated'
      redirect_to admin_region_bulk_mail_path @region, @bulk_mail
    else
      flash[:alert] = @bulk_mail.errors.full_messages.to_sentence
      render :edit
    end
  end
end
