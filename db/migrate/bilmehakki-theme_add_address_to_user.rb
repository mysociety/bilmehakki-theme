# -*- encoding : utf-8 -*-
class BilmehakkiThemeAddAddressToUser < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :address, :text
  end

  def self.down
    remove_column :users, :address
  end
end
