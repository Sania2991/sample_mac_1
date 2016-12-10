class UsersController < ApplicationController

  # p_248
  def show
    # params[:id] - позволяет считать из поисковой строки номер id ../users/1
    @user = User.find(params[:id])
    # останавливает программу и позволяет работать в консоли c этого места
    # debugger
  end

  def new
    @user = User.new
  end

  # p_262: метод, обрабатывающий неудачную регистрацию.
  def create
    @user = User.new(user_params)
    if @user.save
      # p_313: автоматический вход после регистрации
      # метод доступен,т.к.прописали в app/controllers/appication_controller.rb
      log_in @user
      # p_277: кратковременные сообщения
      flash[:success] = "Welcome to the Sample App!"
      # обрабатывает успешное сохранение
      # переадресация на другую страницу
      redirect_to @user
      # redirect_to @user == redirect_touser_url(@user)
    else
      render 'new'
    end
  end


  # p_265: приватный метод, т.к. user_params будут использоваться только внутри
    # контроллера Users
  private

  def user_params
    # p_264: наличие user - обязательно, остальные - разрешены.
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

end








