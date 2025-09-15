require "test_helper"

class User::SignalUserTest < ActiveSupport::TestCase
  setup do
    @user = users(:david)
  end

  test "belongs to a Signal::User" do
    assert_not_nil @user.external_user_id
    assert_equal signal_users("37s_fizzy_david"), @user.external_user
  end

  test "peering" do
    assert_equal @user, @user.external_user.peer
  end

  test "deactivate clears signal user" do
    users(:jz).deactivate

    assert_nil users(:jz).reload.external_user
  end
end
