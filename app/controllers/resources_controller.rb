class ResourcesController < ApplicationController
  def index; end

  def data_portals
    @data_portals = YAML.load_file "#{Rails.root}/app/views/resources/data_portals.yml"
  end

  def tech
    @tech = YAML.load_file "#{Rails.root}/app/views/resources/tech.yml"
  end
end
