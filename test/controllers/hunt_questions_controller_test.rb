require 'test_helper'

class HuntQuestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hunt_question = hunt_questions(:one)
    @competition = competitions(:one)
    @user = users(:one)
    @last_hunt_question = hunt_questions(:two)
    sign_in @user
  end

  test 'should get scavenger_hunt' do
    get scavenger_hunt_path
    assert_response :success
  end

  test 'should redirect on hunt not published' do
    @competition.update hunt_published: false
    get scavenger_hunt_path
    assert_redirected_to root_path
  end

  test 'should award question' do
    @hunt_question.update! answer: 'AAAbbbCCC'
    assert_difference 'Assignment.count', 1 do
      patch hunt_question_path(@hunt_question), params: {
        hunt_question: {
          answer: 'AAAbbbCCc'
        }
      }
    end
    assert_redirected_to scavenger_hunt_path
    assert flash[:notice].present?
  end

  test 'should ask to try again' do
    assert_no_difference 'Assignment.count' do
      patch hunt_question_path(@hunt_question), params: {
        hunt_question: {
          answer: 'Wrong Answer'
        }
      }
    end
    assert_redirected_to scavenger_hunt_path
    assert flash[:alert].present?
  end

  test 'should award hunt badge' do
    Assignment.create!(
      user: @user,
      assignable: @hunt_question,
      holder: holders(:one),
      title: ASSIGNEE
    )

    assert_difference 'Assignment.count', 2 do
      patch hunt_question_path(@last_hunt_question), params: {
        hunt_question: {
          answer: @last_hunt_question.answer
        }
      }
    end
  end

  test 'should save nothing if something goes wrong' do
    Assignment.create!(
      user: @user,
      assignable: @hunt_question,
      holder: holders(:one),
      title: ASSIGNEE
    )

    Assignment.create!(
      user: @user,
      assignable: @competition.hunt_badge,
      holder: holders(:one),
      title: ASSIGNEE
    )

    assert_no_difference 'Assignment.count' do
      @competition.update! hunt_badge_id: nil
      assert_raises(NoMethodError) do
        patch hunt_question_path(@last_hunt_question), params: {
          hunt_question: {
            answer: @last_hunt_question.answer
          }
        }
      end
    end
  end
end
