# frozen_string_literal: true

class API::V1::ProjectsController < API::V1::BaseController
  def show
    project = Project.find(params[:id])

    render json: {data: ProjectBlueprint.render_as_hash(project)}
  end

  def index
    render json: {data: ProjectBlueprint.render_as_hash(Project.all)}
  end
end
