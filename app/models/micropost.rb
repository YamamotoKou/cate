class Micropost < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_many :likes,     dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :contents,  dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
  has_many :notifications, dependent: :destroy
  accepts_nested_attributes_for :contents,
    reject_if: lambda {|attributes| attributes['title'].blank? || 
                                    attributes['sentence'].blank? ||
                                    attributes['price'].blank?}
  # 投稿日時が早いものが上に来るように取得
  default_scope -> { order(created_at: :desc) }
  # 検索（投稿タイトル OR コンテンツタイトル）
  scope :search, -> ( keyword ){
    joins(:contents).where("text like ? OR contents.title like ? ", "%#{keyword}%", "%#{keyword}%") if keyword.present?
  }
  validates :user_id, presence: true
  validates :text, presence: true, length: { maximum: 140 }
  validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
                                      message: "must be a valid image format" },
                      size: { less_than: 5.megabytes,message: "should be less than 5MB" }
  
  def self.trend
    find(Like.group(:micropost_id).order(Arel.sql('count(micropost_id) desc')).limit(5).pluck(:micropost_id))
  end

  #画像のリサイズ
  def center_container_image
    image.variant(resize_to_fill: [310, 310])
  end

  def right_container_image
    image.variant(resize_to_fill: [250, 250])
  end

  def transacted_image
    image.variant(resize_to_fill: [100, 100])
  end

  def create_notification_like!(current_user)
    temp = Notification.where(["sender_id = ? and recipient_id = ? and micropost_id = ? and action = ? ",current_user.id, user_id, id, 'like'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        micropost_id: id,
        recipient_id: user_id,
        action: 'like'
      )

      if notification.sender_id == notification.recipient_id
         notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

end