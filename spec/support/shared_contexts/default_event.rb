# frozen_string_literal: true

RSpec.shared_context 'with default event' do
  let(:default_competition) { create(:competition) }
  let(:default_region) { create(:region, competition: default_competition) }
  let(:default_event) { create(:event, region: default_region) }
end
