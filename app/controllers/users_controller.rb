class UsersController < ApplicationController

  # p_362: Вызов определённого метода до определенных действий
  # По умолчанию предварительные фильтры применяются ко всем методам контроллера
    # хэш :only - ограничивает фильтр только к методам :edit и :update.
  # открыть страницу update и edit может только зарегестриров. пользователь
  before_action :logged_in_user, only: [:edit, :update]
  # p_368: предварительный фильтр для второго пользователя
  before_action :correct_user,   only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end


  # p_352:
  def edit
    @user = User.find(params[:id])
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



  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end


  # p_362: предварительные фильтры
    # Подтверждает вход пользователя
  def logged_in_user
    unless logged_in?
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

end








