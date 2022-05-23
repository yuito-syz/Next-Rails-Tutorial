require "test_helper"

class Api::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_users_index_url
    assert_response :success
  end

  test "should get show" do
    get api_users_show_url
    assert_response :success
  end

  test "should get create" do
    get api_users_create_url
    assert_response :success
  end

  test "should get update" do
    get api_users_update_url
    assert_response :success
  end

  test "should get destroy" do
    get api_users_destroy_url
    assert_response :success
  end

  test "should get following" do
    get api_users_following_url
    assert_response :success
  end

  test "should get followers" do
    get api_users_followers_url
    assert_response :success
  end

  test "should get likes" do
    get api_users_likes_url
    assert_response :success
  end
end
