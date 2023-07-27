# frozen_string_literal: true

RSpec.describe EventBlueprint do
  subject { described_class.render_as_hash(event) }

  let(:event) { create(:event, id: 1234, region: region) }
  let(:region) { create(:region, competition: create(:competition)) }

  it 'renders the event' do
    expect(subject).to eq(
      {
        id: 1234,
        region_id: region.id,
      },
    )
  end
end
