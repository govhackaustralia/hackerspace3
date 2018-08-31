class DataSetsController < ApplicationController
  def index
    @competition = Competition.current
    @regions = Region.all
    @region_sets = @competition.filter_data_sets(params[:term])
    respond_to do |format|
      format.html
      format.csv { send_data @data_sets.to_csv }
    end
  end

  def show
    @data_set = DataSet.find(params[:id])
    return if Competition.current.started?
    redirect_to root_path
  end
end
