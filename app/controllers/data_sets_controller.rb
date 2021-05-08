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
    @data_set = DataSet.find(params[:id])
    @team_data_sets = TeamDataSet.where(url: @data_set.url)
    @teams = Team.published.where(id: @team_data_sets.pluck(:team_id)).preload(:current_project)
  end
end
