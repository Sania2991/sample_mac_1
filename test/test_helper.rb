ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"                                                     # p_119 ...
Minitest::Reporters.use!                                                         # ... p_119

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
 include ApplicationHelper                                                       # P_198
  # Add more helper methods to be used by all tests here...

  # p_314: логический метод определения входа внутри тестов
  # возвращает true, усли тестовый пользователь вошел
  def is_logged_in?
    !session[:user_id].nil?
  end

end
