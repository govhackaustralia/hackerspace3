# frozen_string_literal: true

RSpec.describe '/api/v1/projects' do
  include_context 'with default event'

  before do
    create(:project,
      id: 1,
      team: create(:team, event: default_event),
      user: create(:user),
      project_name: 'My awesome project',
      description: 'Does something cool',
      team_name: 'My Team',
    )

    create(:project,
      id: 2,
      team: create(:team, event: default_event),
      user: create(:user),
      project_name: "I'm not creative",
      description: 'Some description',
      team_name: 'Pied Piper',
    )
  end

  it 'returns a list of projects' do
    get '/api/v1/projects'

    expect(response).to have_http_status(:success)
    parsed_body = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_body.fetch(:data)).to eq(
      [
        {
          id: 1,
          project_name: 'My awesome project',
        },
        {
          id: 2,
          project_name: "I'm not creative",
        },
      ],
    )
  end

  context 'with many projects' do
    before do
      Project.destroy_all
      base_time = DateTime.parse('2020-02-03 13:00:00')
      team = create(:team, event: default_event)
      user = create(:user)
      50.times do |n|
        create(:project,
          project_name: "Project #{n + 1}",
          created_at: base_time + n.minutes,
          team: team,
          user: user,
        )
      end
    end

    it 'returns a paginated list of projects ordered by created_at, newest first' do
      get '/api/v1/projects?page=2'
      expect(response).to have_http_status(:success)

      parsed_body = JSON.parse(response.body, symbolize_names: true)
      receieved_data = parsed_body.fetch(:data)
      expect(receieved_data.length).to eq(20)

      expected_project_names = (11..30).to_a.reverse.map { "Project #{_1}" }
      expect(receieved_data.map { _1[:project_name] }).to eq(expected_project_names)

      expect(parsed_body.fetch(:links)).to match(
        next: '/api/v1/projects?page=3',
        prev: '/api/v1/projects?page=1',
        first: '/api/v1/projects?page=1',
        last: '/api/v1/projects?page=3',
      )
    end
  end
end
