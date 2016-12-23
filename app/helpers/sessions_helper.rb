module SessionsHelper

  # p_301: определили функцию log_in, т.к. подход к организации входа
  # потребуется в 2 разных местах
  # осуществляется вход данного пользователя
  def log_in(user)
    session[:user_id] = user.id
  end

  # Запоминание пользователя в постоянном сеансе.
  # p_326:
  def remember(user)
    # Запоминает пользователя в Б.Д.: app/models/user.rb
    user.remember
    # p_323: сохранение индификатора пользователя в cookie
    # использ. подписанные cookies, которые шифруются перед отправкой браузеру.
    # cookies.signed[:user_id] = user.id
    # но т.к. нам нужна пара: индиф. и пост. токен, тогда:
    # p_323: метод .permanent - срок действия cookie на 20 лет
    cookies.permanent.signed[:user_id] = user.id
    # p_324: убеждаемся в совпадении токена
    cookies.permanent[:remember_token] = user.remember_token
  end


  # p_306: поиск текущего пользователя в сеансе, используя сжатый метод
  # возращает текущего вошедшего пользователя (если есть).
  # Ruby соглашение о хранении результатов find_by в переменной
  # def current_user
  #   @current_user ||= User.find_by(id: session[:user_id])
  # end

  # p_326: изменили: Возвращает польователя, соответствующего токену в cookie.
  # нам требется сначала получить пользователя из временного сеанса и, только
    # если отсутствует session[:user_id], выполнить поиск по cookies[:user_id].
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      # p_344: закомментировали
      #raise  #Если тест выполн. успешно => эта ветвь не охвачена тестированием
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # p_307: вспомогательный метод logged_in?
  # возвращает true, если пользователь зарегистрирован, иначе возвращает false.
  def logged_in?
    # пользователь считается зарегистрированным, если current_user отлично nil.
    !current_user.nil?
  end


  # p_330: Выход из постоянного сеанса: закрывает постоянный сеанс
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end


  # p_316: осуществляется выход текущего пользователя
  def log_out
    forget(current_user)
    session.delete(:user_id)
    # p_315: внизу пояснение: редкая комбинация, но нужна для безопасности
    @current_user = nil
  end

end
