# -*- encoding : utf-8 -*-
# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#

Rails.configuration.to_prepare do

  PublicBodyController.class_eval do

    before_filter :get_turkish_alphabet, :only => [:list]

    def get_turkish_alphabet
      @turkish_alphabet = ["A","B","C","Ç","D","E","Ğ","F","G","H","İ","I","J","K","L","M","N","Ö","O","P","R","S","Ş","Ü","T","U","V","Y","Z"]
    end

  end

  UserController.class_eval do
    private
    def user_params(key = :user)
      params[key].slice(:name, :email, :password, :password_confirmation, :identity_card_number)
    end
  end

end
