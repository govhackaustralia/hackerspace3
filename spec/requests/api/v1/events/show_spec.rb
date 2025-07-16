# frozen_string_literal: true

RSpec.describe '/api/v1/events' do
  before do
    create(:event, id: 1, region: region)
  end
  let(:region) { create(:region, competition: create(:competition)) }
  let(:requested_id) { 1 }

  it 'returns the requested event' do
    get "/api/v1/events/#{requested_id}"

    expect(response).to have_http_status(:success)
    parsed_body = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_body.fetch(:data).slice(:id)).to include(
      {
        id: 1,
      },
    )
  end

  context "when the event doesn't exist" do
    let(:requested_id) { 2 }

    it 'returns a 404 with the expected structure' do
      get "/api/v1/events/#{requested_id}"

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
