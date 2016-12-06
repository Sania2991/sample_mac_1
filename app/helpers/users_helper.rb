module UsersHelper

  # p_251: Возвращает граватар для данного пользователя
  # p_286: options ...
  def gravatar_for(user, options = { size: 80})
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    # p_286
    size = options[:size]
    # p_286: size ...
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    # img возвращается с CSS-классом и  атрибутом alt
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

end
