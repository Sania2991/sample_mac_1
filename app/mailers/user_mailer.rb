class UserMailer < ApplicationMailer

  # p_408: отправка ссылки на страницу активации учетной записи
  def account_activation(user)
    @user = user
    # p_408: адрес получателя; subject - тема письма
    mail to: user.email, subject: "Account activation"
    # p_407: переменная экземпляра - доступна в представлениях объекта рассылки
    # @greeting = "Hi"
  end

  # p_436: отправка ссылки на срос пароля
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end

end
