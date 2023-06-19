# frozen_string_literal: true

class API::V1::ProjectsController < API::V1::BaseController
  def show
    project = Project.find(params[:id])

    render json: {data: ProjectBlueprint.render_as_hash(project)}
  end

  def index
    pagy, projects = pagy(Project.order(created_at: :desc))
    render json: {
      links: pagy_index_links(pagy),
      data: ProjectBlueprint.render_as_hash(projects)
    }
  end
end
