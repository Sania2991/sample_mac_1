class User < ApplicationRecord
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
end
