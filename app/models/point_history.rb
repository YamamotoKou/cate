class PointHistory < ApplicationRecord
  belongs_to :user
  belongs_to :transaction_log
end
