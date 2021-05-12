class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :sender, class_name: "User", optional: true
  belongs_to :recipient, class_name: "User", optional: true
  belongs_to :micropost, optional: true
  validates :sendeer_id, presence: true
  validates :recipient_id, presence: true
  ACTION_VALUES = ["like", "follow", "transaction"]
  validates :action,  presence: true, inclusion: {in:ACTION_VALUES}
  validates :checked, inclusion: {in: [true,false]}
end
