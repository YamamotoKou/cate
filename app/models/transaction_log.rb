class TransactionLog < ApplicationRecord
  belongs_to :content
  has_many :point_histories
  belongs_to :seller, class_name: "User"
  belongs_to :buyer, class_name: "User"
end