# This migration comes from spree_wallet (originally 20130715130434)
class AddStoreCreditsToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :store_credits_total, :decimal, :precision => 10, :scale => 2, :default => 0.0
  end
end
