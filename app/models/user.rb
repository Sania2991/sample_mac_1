class User < ApplicationRecord
  # p_404: создание доступного атриута
  # p_434: доступность атрибута :reset_token
  attr_accessor :remember_token, :activation_token, :reset_token
  # p_403: предпочтительный использовать ссылки на метода, нежели блок
  # -p_404: before_save {email.downcase! }
  before_save :downcase_email
  # p_403: дайджест токуна активации должен сохр. только при создании польз.
  before_create :create_activation_digest

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  # p_360: разрешение пустых паролей (при редактировании пользователя)
  validates :password, length: {minimum: 6}, allow_blank: true


  class << self

    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ?
             BCrypt::Engine::MIN_COST :
             BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end

  end


  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end


  # p_419: переписали метод: т.к. он специализировался для токена запоминания
  # def authenticated?(remember_token)
  #  return false if remember_digest.nil?
  #  BCrypt::Password.new(remember_digest).is_password?(remember_token)
  # end
  # p_418: возвращает true, если указанный токен соответствует дайджесту
    #  attribute - стал символом :activation
  def authenticated?(attribute, token)
    # p_418: метод send - позволяет вызывать метод по его названию
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    # тут и происходит наше сравнение remember_digest с token
    BCrypt::Password.new(digest).is_password?(token)
  end

 def forget
    update_attribute(:remember_digest, nil)
  end


  # p_426: Активирует учетную запись
  def activate
    # p_427: избавились от переменной user, т.к. внутри модели User ее нет
    # -user.update_attribute(:activated,    true)
    # вместо user можно было использ. self, но внутри модели можно не употребл.
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end


  # p_426: Посылает письмо со ссылкой на страницу активации
  def send_activation_email
    # p_427: заменили @user на self
      # UserMailer.account_activation(@user).deliver_now
    UserMailer.account_activation(self).deliver_now
  end

  # p_435: Устанавливает атрибуты для сброса пароля
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # p_435: Посылает письмо со ссылкой на форму ввода нового пароля.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Возвращает true, если время для сброса пароля истекло.
  def password_reset_expired?
    # Знак "<" - следует читать, как "ранее чем" => ссылка на сброс отправлена
      # раньше, чем два часа назад.
    reset_sent_at < 2.hours.ago
  end


  # p_403: т.к. методы используются только в User, делаем их приватными.
  private

    # p_404: преобразует адрес электронной почты в нижний регистр
      # используется выше в before_save (перед. сохранением)
    def downcase_email
      self.email = email.downcase
    end

    # p_404: создает и присваивает токен активации и его дайджет.
      # когда новый польз. создается посредством User.new - он получ. оба атриб.
      # используется выше в before_create (перед созданием)
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

end
