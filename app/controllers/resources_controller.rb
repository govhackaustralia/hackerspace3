class ResourcesController < ApplicationController
  def index
    @any_tech = @competition.resources.tech.any?
    @any_data_portals = @competition.resources.data_portal.any?
    @information = @competition.resources.information.order(position: :asc)
  end

  def data_portals
    @data_portals = @competition.resources.data_portal.order(position: :asc)
  end

  def tech
    @tech = @competition.resources.tech.order(position: :asc)
  end
end
