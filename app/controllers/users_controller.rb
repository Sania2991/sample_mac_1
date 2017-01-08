class UsersController < ApplicationController

  # p_362: Вызов определённого метода до определенных действий
  # По умолчанию предварительные фильтры применяются ко всем методам контроллера
    # хэш :only - ограничивает фильтр только к методам :edit и :update.
  # открыть страницу update и edit может только зарегестриров. пользователь
  # p_375: вносим index в список защищенных фильтром logged_in_user
  # p_391: добав. destroy, т.к. пользователь перед удал. должен быть авториз.
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  # p_368: предварительный фильтр для подтверждения прав пользователя.
  before_action :correct_user,   only: [:edit, :update]
  # p_391: Предварительный метод, огранич. доступ к методу destroy
  before_action :admin_user,     only: :destroy


  # p_375: добавляем метод index для отображения html
  def index
    # p_376: для отобр. всех польз. созд. перем. со списком всех
    # -p_382: @users = User.all
    # p_382: постраничный вывод списка пользователей в методе index
    @users = User.paginate(page: params[:page], per_page: 30)
  end


  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      # -p_414: log_in @user
      # flash[:success] = "Welcome to the Sample App!"
      # redirect_to @user
      # p_414: добавление активации уч. записи в процедуру регистрации пользов.
      # .deliver_now - отправление email'a
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account. "
      # переадресов. на гл. страницу, т.к. необходимо сначала активир. уч. зап.
      redirect_to root_url
    else
      render 'new'
    end
  end


  # p_352:
  def edit
    # p_367: убрали, т.к. фильтр correct_user определяет переменную @user в
      # методах edit и update
    # @user = User.find(params[:id])
  end


  # p_356: Обновление информации о пользователе
  def update
    @user = User.find(params[:id])
    # p_356: user_params для предотвращ. уязвимости (использ. строгие параметры)
    if @user.update_attributes(user_params)
      # p_359: необходим для прохождения тестов
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  # p_391: Добавление метода удаления пользователя (для админов)
  def destroy
    # p_391: сделали цепочку методов, объединив find и destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end



  private


  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end


  # p_362: предварительные фильтры
    # Подтверждает вход пользователя
  def logged_in_user
    unless logged_in?
      # p_372: использ. фильтр store_location (запомин. URL) в session_helper.rb
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end


  # p_368: подтверждает права пользователя
  def correct_user
    @user = User.find(params[:id])
    # возвращает на главную страницу, если данный пользов. не текущий
    redirect_to(root_url) unless current_user?(@user)
  end


  # p_391: подтверждает наличие административных привилегия.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end


  # p_391: подтверждает наличие административных привилегей перед мет. destroy
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end


end








