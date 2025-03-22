require "test_helper"

class UserInvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_invitation = user_invitations(:one)
  end

  test "should get index" do
    get user_invitations_url
    assert_response :success
  end

  test "should get new" do
    get new_user_invitation_url
    assert_response :success
  end

  test "should create user_invitation" do
    assert_difference("UserInvitation.count") do
      post user_invitations_url, params: { user_invitation: {} }
    end

    assert_redirected_to user_invitation_url(UserInvitation.last)
  end

  test "should update user_invitation" do
    patch user_invitation_url(@user_invitation), params: { user_invitation: {} }
    assert_redirected_to user_invitation_url(@user_invitation)
  end

  test "should destroy user_invitation" do
    assert_difference("UserInvitation.count", -1) do
      delete user_invitation_url(@user_invitation)
    end

    assert_redirected_to user_invitations_url
  end
end
