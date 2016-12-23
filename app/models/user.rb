class User < ApplicationRecord
  # p_321: создание доступного атрибута
  attr_accessor :remember_token
  # p_228 гарантия уникальности атрибута  email за счет нижнего регистра
  # p_237: упростили
  before_save {email.downcase! }
  # p_215-218
  # проверка наличия значения в атрибуте name
  validates :name, presence: true, length: { maximum: 50 }
  # p_222
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    #uniqueness: true    # уникальность
  # p_229: Метод для поддержки паролей => * атрибут password_digest
  #                                       * password и password_confirmation
  #                                       * метод authenticate
  has_secure_password
  validates :password, length: {minimum: 6}

  # Возвращает дайджест для указанной строки
  # p_311: добавление метода digest для использования в тестах, его доступ.
  # исп. мин. параметр cost в тестах, и норм. в эксплуатационном режиме.
  # теперь можно определить тестовые данные в: test/fixtures/users.yml
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ?
           BCrypt::Engine::MIN_COST :
           BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Возвращает случайный токен
  # p_321: т.к. методу не требуется экземпляр объекта,
    # то определяем, как метод класса (правило)
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Запоминает пользователя в Б.Д. для использования в постоянных сеансах
  # p_321: из-за особенностей присваивания внутри объектов без ссылки self эта
    # операция создаст локальную переменную remember_token, которая на совсем
    # не нужна. Ссылка self гарантирует, что присваивание будет выполнено
    # пользовательскому атрибуту remember_token.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end


  # Возвращает true, если указанный токен соответствует дайджесту.
  # p_325: remember_token не имеет ничего общего с remember_token выше(remember)
  # Это локальная переменная метода (т.к. аргумент относится к токену, нет
    # ничего странного в использовании такого же названия).
  def authenticated?(remember_token)
    # p_334: Добавление в authenticated? обработки несуществующего дайджеста
    return false if remember_digest.nil?
    # p_324-325: обратите внимание: remember_digest это тоже самое, что и
      # self.remember_digest, создается автомат. на основ. имени столбца в Б.Д.
      # p_324: можно записать и через == , т.к. внутри метод переопределен.
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end


  # p_330: Забывает пользователя:  метод просто отменяет всё сделанное
    # методом user.remember, присваивая дайджесту значение nil
  def forget
    update_attribute(:remember_digest, nil)
  end

end
