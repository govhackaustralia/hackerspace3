require 'test_helper'

class Admin::Sponsors::SponsorshipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @sponsorship = sponsorships(:one)
    @sponsor = sponsors(:one)
  end

  test 'should delete destroy success' do
    assert_difference 'Sponsorship.count', -1 do
      delete admin_sponsor_sponsorship_url @sponsor, @sponsorship
    end
    assert_redirected_to admin_competition_sponsor_path(
      @sponsor.competition_id, @sponsor
    )
  end
end
