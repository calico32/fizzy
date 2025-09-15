module User::SignalUser
  extend ActiveSupport::Concern

  prepended do
    # the external_user_id is the SignalId::User id
    belongs_to :external_user, dependent: :destroy, class_name: "SignalId::User", optional: true
  end

  class_methods do
    def find_by_signal_user_id(signal_user_id)
      find_by(external_user_id: signal_user_id)
    end
  end

  def deactivate
    super
    SignalId::Database.on_master { external_user&.destroy }
  end
end
