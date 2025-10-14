require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get games_new_url
    assert_response :success
  end

  test "should get move" do
    get games_move_url
    assert_response :success
  end

  test "should get show" do
    get games_show_url
    assert_response :success
  end
end
