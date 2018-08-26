class DataSetsController < ApplicationController
  def index
    @competition = Competition.current
    @data_sets = @competition.data_sets
  end

  def show
    @data_set = DataSet.find(params[:id])
  end
end
