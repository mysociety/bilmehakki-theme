# -*- encoding : utf-8 -*-
# Here you can override or add to the pages in the core website

Rails.application.routes.draw do
  match '/profile/address/edit' => 'user_address#edit',
        :as => :user_edit_address,
        :via => :get

  match '/profile/address' => 'user_address#update',
        :as => :user_update_address,
        :via => :put

  match '/profile/identity_card_number/edit' => 'user_identity_card_number#edit',
        :as => :user_edit_identity_card_number,
        :via => :get

  match '/profile/identity_card_number' => 'user_identity_card_number#update',
        :as => :user_update_identity_card_number,
        :via => :put
end
