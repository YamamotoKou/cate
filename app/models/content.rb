class Content < ApplicationRecord
  belongs_to :micropost
  has_many :transaction_logs
  enum status: { free: 0, paid: 1 }
end