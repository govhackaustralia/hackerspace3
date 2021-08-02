require 'test_helper'

class VisitsControllerTest < ActionDispatch::IntegrationTest
  test 'post create data set visit' do
    assert_difference 'Visit.count' do
      post visits_path(params: {
        visit: {
          visitable_id: 1,
          visitable_type: 'DataSet'
        }
      })
    end
    assert_redirected_to data_sets(:one).url
  end

  test 'post create resource visit' do
    assert_difference 'Visit.count' do
      post visits_path(params: {
        visit: {
          visitable_id: 1,
          visitable_type: 'Resource'
        }
      })
    end
    assert_redirected_to resources(:one).url
  end

  test 'post create sponsor visit' do
    assert_difference 'Visit.count' do
      post visits_path(params: {
        visit: {
          visitable_id: 1,
          visitable_type: 'Sponsor'
        }
      })
    end
    assert_redirected_to sponsors(:one).url
  end
end
