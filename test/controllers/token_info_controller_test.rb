require 'test_helper'

class TokenInfoControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get token_info_show_url
    assert_response :success
  end

end
