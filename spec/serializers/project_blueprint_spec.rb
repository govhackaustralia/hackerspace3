# frozen_string_literal: true

RSpec.describe ProjectBlueprint do
  include_context 'with default event'

  subject { described_class.render_as_hash(project) }

  let(:project) do
    create(:project,
      id: 1234,
      project_name: 'Pied Piper',
      team_name: 'Aviato',
      team: create(:team, event: default_event),
      user: create(:user),
    )
  end

  it 'renders the project' do
    expect(subject).to eq(
      {
        id: 1234,
        project_name: 'Pied Piper',
      },
    )
  end
end
