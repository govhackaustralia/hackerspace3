# frozen_string_literal: true

class API::V1::EventsController < API::V1::BaseController
  def index
    pagy, events = pagy(Event.order(created_at: :desc))
    render json: {
      links: pagy_index_links(pagy),
      data: EventBlueprint.render_as_hash(events),
    }
  end
end
