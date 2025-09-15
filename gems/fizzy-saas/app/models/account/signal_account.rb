module Account::SignalAccount
  extend ActiveSupport::Concern

  prepended do
    # the tenant_id column is the SignalId::Account's queenbee_id
    belongs_to :external_account, class_name: "SignalId::Account", primary_key: :queenbee_id, foreign_key: :tenant_id, optional: true
  end

  class_methods do
    def find_by_queenbee_id(queenbee_id)
      find_by(tenant_id: queenbee_id)
    end

    def create_with_admin_user(tenant_id:)
      new(tenant_id:).tap do |account|
        SignalId::Database.on_master do
          account.name = account.external_account.name
          account.save!

          User.create!(
            name:             account.external_account.owner.name,
            email_address:    account.external_account.owner.email_address,
            external_user_id: account.external_account.owner.id,
            role:             "admin",
            password:         SecureRandom.hex(36) # TODO: remove password column?
          )
        end
      end
    end
  end
end
