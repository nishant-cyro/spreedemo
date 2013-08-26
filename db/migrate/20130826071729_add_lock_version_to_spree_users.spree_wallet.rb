# This migration comes from spree_wallet (originally 20130729071647)
class AddLockVersionToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :lock_version, :integer, :default => 0
  end
end
