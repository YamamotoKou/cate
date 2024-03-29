class User < ApplicationRecord
  has_one_attached :avatar
  has_one_attached :header_image
  has_many :microposts,       dependent: :destroy
  has_many :entries,          dependent: :destroy
  has_many :direct_messages,  dependent: :destroy
  has_many :likes,            dependent: :destroy
  has_many :bookmarks,        dependent: :destroy
  has_many :point_histories,  dependent: :destroy
  has_many :transaction_buyer_logs, class_name: "TransactionLog", foreign_key: :buyer_id
  has_many :transaction_seller_logs, class_name: "TransactionLog", foreign_key: :seller_id
  has_many :rooms,            through: :entries
  has_many :liked_posts,      through: :likes, source: :micropost
  has_many :bookmark_posts,   through: :bookmarks, source: :micropost
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :following,             through: :active_relationships,
                                   source: :followed
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :followers,             through: :passive_relationships, 
                                   source: :follower
  has_many :active_notifications,  class_name: "Notification",
                                   foreign_key:"sender_id",
                                   dependent: :destroy
  has_many :passive_notifications, class_name: "Notification",
                                   foreign_key:"recipient_id",
                                   dependent: :destroy

  #Transactionのbuyer_id,seller_idを外部キーに．
  has_many :buy_transaction_logs,  class_name:  "TransactionLog",
                                   foreign_key: "buyer_id"
  has_many :sell_transaction_logs, class_name:  "TransactionLog",
                                   foreign_key: "seller_id"

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  #[!]で直接emailの値を小文字にする．
  before_save { email.downcase! }
  validates :name,  presence: true, length: { maximum: 50 }, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    # 一方のブラウザでログアウトし， もう一方がログインで終了しても, このメソッドを適応（エラー）させないように.
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # ユーザーのログイン情報を破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end

  # アカウントを有効にする
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
    # update_columnsは、モデルのコールバックやバリデーションが実行されない点がupdate_attributeと異なります
    # update_attribute(:activated,    true)
    # update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
    # update_attribute(:reset_digest,  User.digest(reset_token))
    # update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id)
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user # <<演算子（Shovel Operator）で配列の最後に追記することができる
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  def followed_by?(other_user)
    followers.include?(other_user)
  end

  def transacted?(seller_content)
    self.buy_transaction_logs.exists?(content_id: seller_content.id)
  end

  def main_icon_avatar
    avatar.variant(resize_to_fill: [45, 45])
  end

  def sub_icon_avatar
    avatar.variant(resize_to_fill: [35, 35])
  end

  def to_param
    catena_id
  end

  def already_liked?(micropost)
    self.likes.exists?(micropost_id: micropost.id)
  end

  def already_marked?(micropost)
    self.bookmarks.exists?(micropost_id: micropost.id)
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(["sender_id = ? and recipient_id = ? 
                                and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        recipient_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  private

    # メールアドレスをすべて小文字にする
    def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成および代入する
    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
    
end
