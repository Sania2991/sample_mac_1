module SessionsHelper


  def log_in(user)
    session[:user_id] = user.id
  end


  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end


  # p_369: Возвращает true, если данный пользователь - текущий
  def current_user?(user)
    user == current_user
  end


  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # p_420: т.к. переписали метод authenticated? (2 арг. вместо 1-го)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end


  def logged_in?
    !current_user.nil?
  end


  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # p_371: перенаправить по сохраненному адресу или на страницу по умолчанию
  def redirect_back_or(default)
    # p_373: хоть строка переадр. и находится выше, удаление URL произойдет
      # т.к. явной переадр.: return - нет, а метод ещё не закончился
    redirect_to(session[:forwarding_url] || default)
    # p_373: удаляет сохр. URL
    session.delete(:forwarding_url)
  end


  # p_372: запомин. url в session[:forwarding_url], НО! только при GET запросе!
    # это предтвращает сохр., если форму отправл. незарегистр. пользов.
  def store_location
    # использ. объект request для получения URL запрашиваемой страницы
    session[:forwarding_url] = request.url if request.get?
  end

end
