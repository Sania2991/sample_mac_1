ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in order.
  fixtures :all
 include ApplicationHelper
  # Add more helper methods to be used by all tests here...

  # p_314: логический метод определения входа внутри тестов
  # возвращает true, усли тестовый пользователь вошел
  def is_logged_in?
    !session[:user_id].nil?
  end

  # p_340: Вспомогательный метод, выполняет вход тестового пользователя
  # определяет тип теста и выполняет соответствующие операции.
  def log_in_as(user, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  private

    # Возвращает true внутри интеграционного теста.
    def integration_test?
      defined?(post_via_redirect)
    end

end
