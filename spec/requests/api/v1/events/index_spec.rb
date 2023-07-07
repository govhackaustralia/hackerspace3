# frozen_string_literal: true

RSpec.describe '/api/v1/events' do
  before do
    create :event, id: 1, region: region, created_at: Time.current - 4.seconds
    create :event, id: 2, region: region, created_at: Time.current - 2.seconds
  end
  let(:region) { create :region, competition: create(:competition) }

  it 'returns a list of events' do
    get '/api/v1/events'

    expect(response).to have_http_status(:success)
    parsed_body = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_body.fetch(:data)).to match(
      [
        a_hash_including(id: 2),
        a_hash_including(id: 1),
      ],
    )
  end

  context 'with many events' do
    before do
      Event.destroy_all
      base_time = DateTime.parse('2020-02-03 13:00:00')
      50.times do |n|
        create(:event,
          created_at: base_time + n.minutes,
          region: region,
        )
      end
    end

    it 'returns a paginated list of events ordered by created_at, newest first' do
      get '/api/v1/events?page=2'
      expect(response).to have_http_status(:success)

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      receieved_data = parsed_body.fetch(:data)
      expect(receieved_data.length).to eq(20)

      expected_event_ids = (11..30).to_a.reverse
      expect(receieved_data.map { _1[:id] }).to eq(expected_event_ids)

      expect(parsed_body.fetch(:links)).to match(
        next: '/api/v1/events?page=3',
        prev: '/api/v1/events?page=1',
        first: '/api/v1/events?page=1',
        last: '/api/v1/events?page=3',
      )
    end
  end
end
