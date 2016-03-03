# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserIdentityCardNumberController do

  describe 'GET edit' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      session[:user_id] = @user.id
    end

    it 'requires login' do
      session[:user_id] = nil

      get :edit

      post_redirect = get_last_post_redirect
      expect(response).to redirect_to(
        :controller => 'user',
        :action => 'signin',
        :token => post_redirect.token)
    end

    it 'finds the logged in user to edit' do
      get :edit
      expect(assigns[:user]).to eql(@user)
    end

    it 'renders the form for changing the Identity Card Number' do
      get :edit
      expect(response).to render_template('edit')
    end

  end

  describe 'PUT update' do

    before(:each) do
      @user = FactoryGirl.create(:user)
      session[:user_id] = @user.id
    end

    it 'requires login' do
      session[:user_id] = nil

      put :update, { :user => { :identity_card_number => '45678901234' } }

      post_redirect = get_last_post_redirect
      expect(response).to redirect_to(
        :controller => 'user',
        :action => 'signin',
        :token => post_redirect.token)
    end

    it 'finds the logged in user to update' do
      get :edit
      expect(assigns[:user]).to eql(@user)
    end

    it 'changes the users Identity Card Number' do
      put :update, { :user => { :identity_card_number => '45678901234' } }
      expect(User.find(@user.id).identity_card_number).to eql('45678901234')
    end

    it 'does not accept a blank Identity Card Number' do
      put :update, { :user => { :identity_card_number => nil } }
      expect(response).to render_template('edit')
    end

    it 'notifies the user that the update was successful' do
      put :update, { :user => { :identity_card_number => '45678901234' } }
      expect(flash[:notice]).to_not be_nil
    end

    it 'redirects to the user profile page after updating successfuly' do
      put :update, { :user => { :identity_card_number => '45678901234' } }
      path = show_user_profile_path(:url_name => @user.url_name)
      expect(response).to redirect_to(path)
    end

  end

end