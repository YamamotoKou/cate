class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user

  # 投稿日時が早いものが上に来るように取得する設定
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size: { less_than: 5.megabytes,message: "should be less than 5MB" }

  # 表示用のリサイズ済み画像を返す
  def display_image
    image.variant(resize_to_limit: [300, 300])
  end
end