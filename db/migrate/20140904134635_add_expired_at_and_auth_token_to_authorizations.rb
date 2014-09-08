class AddExpiredAtAndAuthTokenToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :expires_at, :datetime
    add_column :authorizations, :auth_token, :string, null: false
    add_index :authorizations, [:provider, :expires_at]
  end
end
