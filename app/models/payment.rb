class Payment < ApplicationRecord
  belongs_to :client
  belongs_to :order

  enum status: { pending: 0, paid: 5, fail: 7}
end
