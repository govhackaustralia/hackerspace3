# frozen_string_literal: true

RSpec.describe '/api/v1/projects' do
  include_context 'with default event'

  before do
    create(:project,
      id: 1,
      team: create(:team, event: default_event),
      user: create(:user),
      project_name: 'My awesome project',
    )
  end

  it 'the requested project' do
    get '/api/v1/projects/1'

    expect(response).to have_http_status(:success)
    parsed_body = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_body.fetch(:data)).to eq(
      {
        id: 1,
        project_name: 'My awesome project',
      },
    )
  end
end
