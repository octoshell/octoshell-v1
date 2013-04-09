module Avatarable
  def avatar_url
    if avatar?
      avatar.url
    else
      Gravatar.new(email).image_url + '?' + {
        s: '116',
        d: "http://#{website_host}/assets/default_avatar.png"
      }.to_param
    end
  end
  
private
  
  def website_host
    Rails.application.config.action_mailer.default_url_options[:host]
  end
end
