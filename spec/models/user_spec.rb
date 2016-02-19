# -*- encoding : utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do

  describe :identity_card_number do

    let(:error_msg) do
      "Please enter your Turkish Identification Number in the correct format"
    end

    it 'has an identity_card_number attribute' do
      user = User.new(:identity_card_number => '12345678901')
      expect(user.identity_card_number).to eq('12345678901')
    end

    it 'can be set' do
      user = User.new
      user.identity_card_number = '12345678901'
      expect(user.identity_card_number).to eq('12345678901')
    end

    it 'is not valid if no identity_card_number is present' do
      user = User.new
      user.valid?
      expect(user.errors[:identity_card_number]).to eq([error_msg])
    end

    it 'does not allow an invalid format' do
      user = User.new
      user.identity_card_number = 'ABCD1234xyz'
      user.valid?
      expect(user.errors[:identity_card_number]).to eq([error_msg])
    end

    it 'cannot have a leading zero' do
      user = User.new
      user.identity_card_number = '01234567890'
      user.valid?
      expect(user.errors[:identity_card_number]).to eq([error_msg])
    end

    it 'allows a valid format' do
      user = User.new
      user.identity_card_number = '12345678901'
      user.valid?
      expect(user.errors[:identity_card_number]).to be_empty
    end

    describe 'updating identity_card_number' do

      before(:each) do
        @user = FactoryGirl.create(:user)
      end

      it "creates a censor rule for the user's identity card number" do
        expect(@user.censor_rules.where(:text => '12345678901').size).to eq(1)
      end

      it 'creates another censor rule when the user changes identity card number' do
        @user.update_attribute(:identity_card_number, '22345678901')
        expect(@user.censor_rules.where(:text => '12345678901').size).to eq(1)
        expect(@user.censor_rules.where(:text => '22345678901').size).to eq(1)
      end

      it 'does not duplicate censor rules' do
        @user.update_attribute(:identity_card_number, @user.identity_card_number)
        expect(@user.censor_rules.where(:text => '12345678901').size).to eq(1)
      end

      it 'creates the censor rule with a replacement message' do
        expect(@user.censor_rules.last.replacement).to eql('REDACTED')
      end

      it 'creates the censor rule with the THEME_NAME as the author' do
        expect(@user.censor_rules.last.last_edit_editor).to eql(THEME_NAME)
      end

      it 'creates the censor rule with a generic comment' do
        comment = 'Updated automatically after_save'
        expect(@user.censor_rules.last.last_edit_comment).to eql(comment)
      end

    end

  end

end