require "test_helper"

class Account::SignalAccountTest < ActiveSupport::TestCase
  # # TODO(MIKE): Queenbee client API compliance tests
  # include Queenbee::Testing::Client

  setup do
    @account = accounts("37s")
  end

  test "belongs to a signal_account via a shared queenbee_id" do
    assert_not_nil @account.tenant_id
    assert_equal @account.tenant_id, Account.new(external_account: @account.external_account).tenant_id
    assert_equal @account.external_account, Account.new(tenant_id: @account.tenant_id).external_account
  end

  test "peering" do
    assert_equal @account, @account.external_account.peer
  end

  test ".create_with_admin_user creates a new local account and user peers" do
    ApplicationRecord.create_tenant("account-create-with-dependents") do
      signal_account = signal_accounts(:honcho_fizzy)
      account = Account.create_with_admin_user(tenant_id: signal_account.queenbee_id)

      assert_not_nil account
      assert account.persisted?
      assert_equal 1, Account.count
      assert_equal signal_account.queenbee_id, account.tenant_id
      assert_equal signal_account.name, account.name
      assert_equal account, signal_account.peer

      assert_equal 1, User.count
      User.first.tap do |user|
        assert signal_account.owner.name, user.name
        assert signal_account.owner.email_address, user.email_address
        assert signal_account.owner.id, user.external_user_id
        assert_equal "admin", user.role
        assert_equal user, signal_account.owner.peer
      end
    end
  end
end
