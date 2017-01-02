class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # p_301: подключили вспомогательный модуль Sessions в контроллере Application,
  # , чтобы он стал доступен во всех контроллерах
  include SessionsHelper
end
