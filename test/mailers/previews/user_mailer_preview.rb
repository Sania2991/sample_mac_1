# p_410: Предварительный просмотр всех писем по адресу:
  # http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # p_410: предварительный просмотр этого письма:
    # http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    # определили перем. user, чтобы метод заработал
    user = User.first
    user.activation_token = User.new_token
    UserMailer.account_activation(user)
  end

  # p_410: предварительный просмотр этого письма:
    # http://localhost:3000/rails/mailers/user_mailer/password_reset
  # p_437: действующий метод прдварительного просмотра для сброса пароля
  def password_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end


end
