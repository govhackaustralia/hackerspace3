class DataSetsController < ApplicationController
  def index
    @competition = Competition.current
    @data_sets = @competition.data_sets
  end
end
