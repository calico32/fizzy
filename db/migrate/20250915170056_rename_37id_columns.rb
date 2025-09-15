class Rename37idColumns < ActiveRecord::Migration[8.1]
  def change
    rename_column :users, :signal_user_id, :external_user_id
    rename_column :accounts, :queenbee_id, :tenant_id
  end
end
