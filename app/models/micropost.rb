class Micropost < ApplicationRecord
  belongs_to :user
  # 投稿日時が早いものが上に来るように取得する設定
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
end