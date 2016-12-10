module SessionsHelper

  # p_301: определили функцию log_in, т.к. подход к организации входа
  # потребуется в 2 разных местах
  # осуществляется вход данного пользователя
  def log_in(user)
    session[:user_id] = user.id
  end

  # p_306: поиск текущего пользователя в сеансе, используя сжатый метод
  # возращает текущего вошедшего пользователя (если есть).
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  # p_307: вспомогательный метод logged_in?
  # возвращает true, если пользователь зарегистрирован, иначе возвращает false.
  def logged_in?
    # пользователь считается зарегистрированным, если current_user отлично nil.
    !current_user.nil?
  end

end
