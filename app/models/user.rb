class User < ApplicationRecord
  # p_228 гарантия уникальности атрибута  email за счет нижнего регистра
  before_save {self.email = email.downcase }
  # p_215-218
  # проверка наличия значения в атрибуте name
  validates :name, presence: true, length: { maximum: 50 }
  # p_222
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: {with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
                    #uniqueness: true    # уникальность
end
