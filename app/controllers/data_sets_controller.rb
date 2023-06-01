# frozen_string_literal: true

class DataSetsController < ApplicationController
  def index
    @data_sets = @competition.data_sets.order(:name).preload(:region)
    respond_to do |format|
      format.html
      format.csv { send_data @data_sets.to_csv @competition }
      format.json { render json: @data_sets }
    end
  end

  def show
    @data_set = DataSet.find(params[:id])
    @team_data_sets = TeamDataSet.where(url: @data_set.url)
    @teams = Team.published.where(id: @team_data_sets.pluck(:team_id)).preload(:current_project)
    respond_to do |format|
      format.html
      format.json { render json: @data_set }
    end
  end
end
