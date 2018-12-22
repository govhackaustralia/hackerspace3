class DataSetsController < ApplicationController
  def index
    @competition = Competition.current
    @regions = Region.all
    @data_sets = @competition.data_sets.preload(:region)
    respond_to do |format|
      format.html
      format.csv { send_data @data_sets.to_csv }
    end
  end

  def show
    @competition = Competition.current
    @data_set = DataSet.find(params[:id])
    @team_data_sets = TeamDataSet.where(url: @data_set.url)
    @teams = Team.published.where(id: @team_data_sets.pluck(:team_id)).preload(:current_project)
  end
end
