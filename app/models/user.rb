class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  #[!]で直接emailの値を小文字にする．
  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  #ハッシュ化したパスワードを保存する．
  #仮想的な属性password, password_confirmationを使えるように．
  #authenticateメソッド, 一致するかどうかを調べるメソッド．
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end
