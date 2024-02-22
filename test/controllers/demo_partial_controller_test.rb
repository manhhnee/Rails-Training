require "test_helper"

class DemoPartialControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get demo_partial_new_url
    assert_response :success
  end

  test "should get edit" do
    get demo_partial_edit_url
    assert_response :success
  end
end
