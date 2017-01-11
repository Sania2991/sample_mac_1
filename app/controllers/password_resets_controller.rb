class PasswordResetsController < ApplicationController

  before_action :get_user,         only: [:edit, :update]
  before_action :valid_user,       only: [:edit, :update]
  # p_444: Проверка окончания срока действия ссылки для сброса пароля. I случай.
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  # p_434: метод create для сброса пароля
  def create
    # p_434: назодим пользов. по адресу почты
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      # p_434: обновляем атрибуты для сброса пароля (в app/models/user.rb)
      @user.create_reset_digest
      # p_435: посылаем письмо со ссылкой на форму ввода нового пароля
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      # p_434: при отправки неверного email
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  # p_444: Метод update для смены пароля. II и III случай.
  def update
    # пароль пустой
    if password_blank?
      flash.now[:danger] = "Password can't be blank"
      render 'edit'
    # обновление пароля прошло успешно
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end


  private

  # p_445: обновление в б.д.
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # p_445: Возвращает true, если пароль пустой.
  def password_blank?
    # проверяем только один пароль, т.к. подтверждение уже проверяется дальше.
    params[:user][:password].blank?
  end

  # p_442: поиск пользов. по  email
  def get_user
    @user = User.find_by(email: params[:email])
  end


  # p_442: подтверждает допустимость пользователя. I случай.
  def valid_user
    #   1). польз существует,
      # 2). уч. зап. активирована,
      # 3). подлиность подтверждена по токену сброса
    unless (@user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
    redirect_to root_url
    end
  end

  # p_445: Проверяет срок действия токена
  def check_expiration
    # Возвр. true, если время для сброса пароля истекло. (в app/models/user.rb)
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end

end
