class DataSetsController < ApplicationController
  def index
    respond_to do |format|
      format.csv { send_data DatasetReport.new(@competition.datasets).to_csv }
      format.html do
        @portals = @competition.region_portals
          .preload(:dataset, :portable)
          .sort_by { |portal| portal.dataset.name }
      end
    end
  end

  def show
    @portal = Portal.find(params[:id])
    @dataset = @portal.dataset
    @region = @portal.portable
    @team_portals = @competition.team_portals.where(dataset: @dataset)
    @teams = Team.published
      .where(id: @team_portals.pluck(:portable_id))
      .preload(:current_project)
  end
end
