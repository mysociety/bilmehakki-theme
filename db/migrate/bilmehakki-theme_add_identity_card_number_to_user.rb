# -*- encoding : utf-8 -*-
class BilmehakkiThemeAddIdentityCardNumberToUser < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :identity_card_number, :string
  end

  def self.down
    remove_column :users, :identity_card_number
  end
end
