class SessionsController < ApplicationController

  def new
  end

  # p_294
  def create
    # p_296  - поиск и аутентификация пользователя по email/password
    # первая строка извлекает инфу опользователе из Б.Д.
    # params[:session][:email] - вводимые данные из /login
    # find_by в случае отсутствия - возвр. nil, а find -> исключение
    # p_347: переопределили обычную переменную user на перем. экземпляра @user
      # теперь в тесте получим доступ к перем. экз. с помощью assigns
    @user = User.find_by(email: params[:session][:email].downcase)
    # любой, кроме nill/false является true сделано с помощью оператора && (и)
    if @user && @user.authenticate(params[:session][:password])
      # осуществляется вход пользователя и переадресовать на страницу профиля.
      # p_302: вход пользователя с помощью временных cookies
      log_in @user
      # p_326: вход и запоминание пользователя
      # по аналогии с log_in, вся осн. работа передается вспом. модулю
      # SessionsHelper, где определен метод remember, вызывающий user.remember,
      # который генерирует токен и сохраняет в Б.Д. его дайджест. Затем вызывает
      # метод cookies, чтобы создать постоянный cookie.
      #remember user

      # p_338: Обработка флажка "Запомни меня". Стоит - запоминает, иначе нет.
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # p_302: компактная форма переадресации, rails автомат.
        # преобр. в user_url(user)
      redirect_to @user
    else
      # p_297 - вовод сообщения, если неправильно.
      # Т.к. метод render -
      # p_300: вместо flash использ. flash.now (показ. до любого др. действия)
      flash.now[:danger] = 'Invalid email/password combination'
      # Создать сообщение об ошибки
      render 'new'
    end
  end

  def destroy
    # p_316: метод добавили в sessions_helper.rb
    # log_out
    # p_333: выполнять вызод только когда пользователь определется как вошедший:
    log_out if logged_in?
    # перенаправление на root_url, в данном случае на нач. страницу
    redirect_to root_url
  end

end
