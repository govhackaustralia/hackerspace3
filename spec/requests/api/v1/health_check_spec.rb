# frozen_string_literal: true

RSpec.describe '/api/v1/health' do
  it 'returns the expected response' do
    get '/api/v1/health'

    expect(response).to have_http_status(:success)
    parsed_body = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_body.fetch(:data)).to eq(
      {
        version: 'unknown',
      },
    )
  end

  context 'when the COMMIT_SHA environment variable is set' do
    around do |example|
      original_value = ENV.fetch('COMMIT_SHA', nil)
      ENV['COMMIT_SHA'] = '797754ec826c9c31591ae409b8f4ca9d7a98ac89'
      example.run
      ENV['COMMIT_SHA'] = original_value
    end

    it 'returns the expected response' do
      get '/api/v1/health'

      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body, symbolize_names: true)

      expect(parsed_body.fetch(:data)).to eq(
        {
          version: '797754ec826c9c31591ae409b8f4ca9d7a98ac89',
        },
      )
    end
  end
end
