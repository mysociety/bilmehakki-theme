require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe AdminRequestController do

  describe 'POST generate_upload_url' do

    it 'creates a user for the authority with a dummy identity card number' do
      user = FactoryGirl.create(:user, :identity_card_number => '11111111111')
      info_request = FactoryGirl.create(:info_request, :user => user)
      post :generate_upload_url, :id => info_request.id
      user = User.where(:email => info_request.public_body.request_email).first
      expect(user.identity_card_number).to eq('11111111111')
    end

    it 'creates a user for the authority with a dummy address' do
      user = FactoryGirl.create(:user, :address => 'Added by system')
      info_request = FactoryGirl.create(:info_request, :user => user)
      post :generate_upload_url, :id => info_request.id
      user = User.where(:email => info_request.public_body.request_email).first
      expect(user.address).to eq('Added by system')
    end

  end

end
