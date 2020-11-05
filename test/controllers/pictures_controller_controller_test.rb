require 'test_helper'

class PicturesControllerControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get pictures_controller_create_url
    assert_response :success
  end

end
