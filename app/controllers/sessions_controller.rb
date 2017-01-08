class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # p_423: предотвращение входа пользователей с неактивными учетн. записями
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        # p_372: определен в sessions_helper.rb
        redirect_back_or user
      else
        # p_423: в случае неактив. польз. => flash и перенапр. на корн URL
        message = "Account not activated. "
        message += "Check yout email for the activation link. "
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
