class AccountActivationsController < ApplicationController

  # p_421: метод edit для активации учётных записей
  def edit
    user = User.find_by(email: params[:email])
    # p_421: !user.activated? - предотвращ. повт. активацию уже актив. уч. зап.
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # p_421: если if выполн. - активируем уч. зап. и обновл. метку времени.
      user.update_attribute(:activated,    true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      debugger
      # также здесь учитывается случай недопустимого токена
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end

end
