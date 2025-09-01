class Account::SettingsController < ApplicationController
  include FilterScoped

  def show
    @account = Account.sole
    @users = User.active
  end
end
