require "signal_id/testing"
require "queenbee/testing/mocks"

module ActiveSupport
  class TestCase
    include SignalId::Testing

    def saas_extension_sign_in_as(user)
      put saas.session_launchpad_path, params: { sig: user.external_user.perishable_signature }
    end
  end
end

Queenbee::Remote::Account.class_eval do
  # because we use the account ID as the tenant name, we need it to be unique in each test to avoid
  # parallelized tests clobbering each other.
  def next_id
    super + Random.rand(1000000)
  end
end
