require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  test "should get average" do
    get :average
    assert_response :success
  end

end
