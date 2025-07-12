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
  let(:requested_id) { 1 }

  it 'the requested project' do
    get "/api/v1/projects/#{requested_id}"

    expect(response).to have_http_status(:success)
    parsed_body = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_body.fetch(:data).slice(:id, :project_name)).to eq(
      {
        id: 1,
        project_name: 'My awesome project',
      },
    )
  end

  context "when the project doesn't exist" do
    let(:requested_id) { 2 }

    it 'returns a 404 with the expected structure' do
      get "/api/v1/projects/#{requested_id}"

      expect(response).to have_http_status(:not_found)
      parsed_body = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_body.fetch(:errors)).to eq(
        [
          {
            status: '404',
            title: 'Record not found',
            detail: 'The record you requested could not be found',
          },
        ],
      )
    end
  end
end
