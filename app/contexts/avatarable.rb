module Avatarable
  def avatar_url
    if avatar?
      avatar.url
    else
      hash = Digest::MD5.hexdigest(email.downcase.strip)
      "https://secure.gravatar.com/avatar/#{hash}" + '?' + {
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
