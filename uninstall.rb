# -*- encoding : utf-8 -*-
# Uninstall hook code here

def table_exists?(table)
  ActiveRecord::Base.connection.table_exists?(table)
end

def column_exists?(table, column)
  if table_exists?(table)
    ActiveRecord::Base.connection.column_exists?(table, column)
  end
end

if ENV['REMOVE_MIGRATIONS']
  # Remove the identity_card_number field to the User model
  if column_exists?(:users, :identity_card_number)
    migration_file_path = '../db/migrate/bilmehakki-theme_add_identity_card_number_to_user'
    require File.expand_path migration_file_path, __FILE__
    BilmehakkiThemeAddIdentityCardNumberToUser.down
  end

  # Remove the address field to the User model
  if column_exists?(:users, :address)
    migration_file_path = '../db/migrate/bilmehakki-theme_add_address_to_user'
    require File.expand_path migration_file_path, __FILE__
    BilmehakkiThemeAddAddressToUser.down
  end
end