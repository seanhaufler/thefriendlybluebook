require 'test_helper'

class CoursesControllerTest < ActionController::TestCase
  test "should get comment" do
    get :comment
    assert_response :success
  end

end
