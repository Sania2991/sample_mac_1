class ApplicationMailer < ActionMailer::Base
  # p_407: адрес по умолчанию (от кого)
  default from: "noreply@example.com"
  # p_407: шаблон 'mailer' - определяет формат письма
  layout 'mailer'
end
