class Content < ApplicationRecord
  belongs_to :micropost
  has_many :transaction_logs
  enum status: { free: 0, paid: 1 }

  def transacted_post
    Micropost.find_by(id: self.micropost_id)
  end
end