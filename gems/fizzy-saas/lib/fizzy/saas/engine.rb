require "signal_id"

module Fizzy
  module Saas
    class Engine < ::Rails::Engine
      isolate_namespace Fizzy::Saas

      # extend application models
      config.to_prepare do
        User.include User::SignalUser
        Account.include Account::SignalAccount
      end

      # moved from config/initializers/queenbee.rb
      Queenbee.host_app = Fizzy

      config.to_prepare do
        Queenbee::Subscription.short_names = Subscription::SHORT_NAMES
        Queenbee::ApiToken.token = Rails.application.credentials.dig(:queenbee_api_token)

        Subscription::SHORT_NAMES.each do |short_name|
          const_name = "#{short_name}Subscription"
          ::Object.send(:remove_const, const_name) if ::Object.const_defined?(const_name)
          ::Object.const_set const_name, Subscription.const_get(short_name, false)
        end
      end

      # moved from config/initializers/signal_id.rb
      config.before_initialize do
        ENV["SIGNAL_ID_SECRET"] = Rails.application.credentials.signal_id_secret
      end

      config.to_prepare do
        SignalId.product = "fizzy"

        db_config = SignalId::Database.default_configuration
        SignalId::Database.load_configuration db_config
        SignalId::Database.enable_rw_splitting!

        silence_warnings do
          SignalId::Account::Peer = Account
          SignalId::User::Peer = User
        end
      end

      config.after_initialize do
        ActiveRecord.yaml_column_permitted_classes << SignalId::PersonName
      end
    end
  end
end
