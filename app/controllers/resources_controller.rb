# frozen_string_literal: true

class ResourcesController < ApplicationController
  def index
    @tech = @competition.resources.tech.order(position: :asc)
    @any_tech = @tech.any?
    @data_portals = @competition.resources.data_portal.order(position: :asc)
    @any_data_portals = @data_portals.any?
    @information = @competition.resources.information.order(position: :asc)
    respond_to do |format|
      format.html
      format.json { render json: {information: @information, tech: @tech, data_portals: @data_portals} }
    end
  end

  def data_portals
    @data_portals = @competition.resources.data_portal.order(position: :asc)
  end

  def tech
    @tech = @competition.resources.tech.order(position: :asc)
  end
end
