require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @new_user = User.new(
      name: "테스트유저",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )
  end

  test "유효한 사용자는 저장되어야 함" do
    assert @new_user.valid?
    assert @new_user.save
  end

  test "이름은 필수항목" do
    @new_user.name = nil
    assert_not @new_user.valid?
    assert_includes @new_user.errors[:name], I18n.t("activerecord.errors.models.user.blank")
  end

  test "이메일은 필수항목" do
    @new_user.email = nil
    assert_not @new_user.valid?
    assert_includes @new_user.errors[:email], I18n.t("activerecord.errors.models.user.blank")
  end

  test "패스워드는 필수항목" do
    @new_user.password = nil
    @new_user.password_confirmation = nil
    assert_not @new_user.valid?
  end

  test "패스워드와 확인이 일치해야 함" do
    @new_user.password_confirmation = "다른비밀번호"
    assert_not @new_user.valid?
  end

  test "이메일 정규화" do
    @new_user.email = " TEST@EXAMPLE.COM "
    @new_user.save
    assert_equal "test@example.com", @new_user.email
  end

  test "연관된 세션이 있어야 함" do
    assert_respond_to @user, :sessions
  end

  test "연관된 워크스페이스 유저가 있어야 함" do
    assert_respond_to @user, :workspace_users
  end

  test "연관된 워크스페이스가 있어야 함" do
    assert_respond_to @user, :workspaces
  end

  test "연관된 보낸 초대장이 있어야 함" do
    assert_respond_to @user, :sent_user_invitations
  end

  test "연관된 받은 초대장이 있어야 함" do
    assert_respond_to @user, :received_user_invitation
  end

  test "사용자 삭제 시 세션도 함께 삭제되어야 함" do
    @new_user.save

    session = Session.create!(user: @new_user)
    session_id = session.id

    assert Session.exists?(id: session_id)

    assert_difference "Session.count", -1 do
      @new_user.destroy
    end

    assert_not Session.exists?(id: session_id)
  end

  test "사용자 삭제 시 워크스페이스 유저도 삭제되어야 함" do
  end
end
