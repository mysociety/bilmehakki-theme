# -*- encoding : utf-8 -*-
# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#
Rails.configuration.to_prepare do

  OutgoingMessage.class_eval do
    def default_letter
      return nil if message_type == 'followup'
      "4982 sayılı Bilgi Edinme Hakkı Kanunu kapsamında aşağıdaki soruların " \
      "cevaplandırılmasını talep ediyorum."
    end
  end

  User.class_eval do
    validates :identity_card_number,
              :format => {
                :with => /\A[1-9]{1}\d{10}\z/,
                :message => _("Please enter your Turkish Identification Number in the correct format")
              }

    validates_presence_of :address, :message => _("Please enter your address")

    after_save :update_censor_rules

    # The "internal admin" is a special user for internal use.
    def self.internal_admin_user
      user = User.find_by_email(AlaveteliConfiguration::contact_email)
      if user.nil?
        password = PostRedirect.generate_random_token
        user = User.new(
            :name => 'Internal admin user',
            :email => AlaveteliConfiguration.contact_email,
            :password => password,
            :password_confirmation => password,
            :address => '[Admin]',
            :identity_card_number => '12345678901')
        user.save!
      elsif user.identity_card_number.nil?
        user.update_attributes(:identity_card_number => '12345678901')
      end

      user
    end

    private

    def update_censor_rules
      censor_rules.where(:text => identity_card_number).first_or_create(
        :text => identity_card_number,
        :replacement => _('REDACTED'),
        :last_edit_editor => THEME_NAME,
        :last_edit_comment => _('Updated automatically after_save')
      )
    end

  end

end
