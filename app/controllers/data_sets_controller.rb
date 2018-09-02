class DataSetsController < ApplicationController
  def index
    @competition = Competition.current
    @regions = Region.all
    @id_regions = Region.id_regions(@regions.pluck(:id))
    @data_sets = @competition.data_sets
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
