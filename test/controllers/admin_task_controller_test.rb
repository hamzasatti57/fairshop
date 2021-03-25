require 'test_helper'

class AdminTaskControllerTest < ActionDispatch::IntegrationTest
  test "should get home" do
    get admin_task_home_url
    assert_response :success
  end

end
