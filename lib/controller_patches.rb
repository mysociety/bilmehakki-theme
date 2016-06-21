# -*- encoding : utf-8 -*-
# Add a callback - to be executed before each request in development,
# and at startup in production - to patch existing app classes.
# Doing so in init/environment.rb wouldn't work in development, since
# classes are reloaded, but initialization is not run each time.
# See http://stackoverflow.com/questions/7072758/plugin-not-reloading-in-development-mode
#

Rails.configuration.to_prepare do

  AdminRequestController.class_eval do
    def generate_upload_url

      if params[:incoming_message_id]
        incoming_message = IncomingMessage.find(params[:incoming_message_id])
        email = incoming_message.from_email
        name = incoming_message.safe_mail_from || @info_request.public_body.name
      else
        email = @info_request.public_body.request_email
        name = @info_request.public_body.name
      end

      user = User.find_user_by_email(email)
      if not user
        user = User.new(:name => name,
                        :email => email,
                        :identity_card_number => '11111111111',
                        :address => 'Added by system',
                        :password => PostRedirect.generate_random_token)
        user.save!
      end

      if !@info_request.public_body.is_foi_officer?(user)
        flash[:notice] = user.email + " is not an email at the domain @" + @info_request.public_body.foi_officer_domain_required + ", so won't be able to upload."
        redirect_to admin_request_url(@info_request)
        return
      end

      # Bejeeps, look, sometimes a URL is something that belongs in a controller, jesus.
      # TODO: hammer this square peg into the round MVC hole
      post_redirect = PostRedirect.new(
        :uri => upload_response_url(:url_title => @info_request.url_title),
      :user_id => user.id)
      post_redirect.save!
      url = confirm_url(:email_token => post_redirect.email_token)

      flash[:notice] = ("Send \"#{CGI.escapeHTML(name)}\" &lt;<a href=\"mailto:#{email}\">#{email}</a>&gt; this URL: <a href=\"#{url}\">#{url}</a> - it will log them in and let them upload a response to this request.").html_safe
      redirect_to admin_request_url(@info_request)
    end
  end

  PublicBodyController.class_eval do

    before_filter :get_turkish_alphabet, :only => [:list]

    def get_turkish_alphabet
      @turkish_alphabet = ["A","B","C","Ç","D","E","Ğ","F","G","H","İ","I","J","K","L","M","N","Ö","O","P","R","S","Ş","Ü","T","U","V","Y","Z"]
    end

  end

  RequestGameController.class_eval do

    def play
      session[:request_game] = Time.now

      @missing = InfoRequest.count_old_unclassified(:conditions => ["prominence = 'normal'"])
      @total = InfoRequest.count
      @done = @total - @missing
      @percentage = (@done.to_f / @total.to_f * 10000).round / 100.0
      @requests = InfoRequest.includes(:public_body, :user).get_random_old_unclassified(3, :conditions => ["prominence = 'normal'"])


      if @missing == 0
        flash[:notice] = _('<p>All done! Thank you very much for your help.</p>')
      end

      @league_table_28_days = RequestClassification.league_table(10, [ "created_at >= ?", Time.now - 28.days ])
      @league_table_all_time = RequestClassification.league_table(10)
      @play_urls = true
    end

  end

  UserController.class_eval do
    private
    def user_params(key = :user)
      params[key].slice(:name, :email, :password, :password_confirmation, :identity_card_number, :address)
    end
  end

end
