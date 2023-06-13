# frozen_string_literal: true

require 'test_helper'

class VisitsControllerTest < ActionDispatch::IntegrationTest
  test 'get create data set visit' do
    assert_difference 'Visit.count' do
      get visits_path(
        params: {
          visit: {
            visitable_id: data_sets(:one).id,
            visitable_type: 'DataSet',
          },
        },
      )
    end
    assert_redirected_to data_sets(:one).url
  end

  test 'get create resource visit' do
    assert_difference 'Visit.count' do
      get visits_path(
        params: {
          visit: {
            visitable_id: resources(:one).id,
            visitable_type: 'Resource',
          },
        },
      )
    end
    assert_redirected_to resources(:one).url
  end

  test 'get create sponsor visit' do
    assert_difference 'Visit.count' do
      get visits_path(
        params: {
          visit: {
            visitable_id: sponsors(:one).id,
            visitable_type: 'Sponsor',
          },
        },
      )
    end
    assert_redirected_to sponsors(:one).url
  end

  test 'get create sponsor no url' do
    sponsors(:one).update! url: nil
    assert_difference 'Visit.count' do
      get visits_path(
        params: {
          visit: {
            visitable_id: sponsors(:one).id,
            visitable_type: 'Sponsor',
          },
        },
      )
    end
    assert_redirected_to root_path
  end
end
