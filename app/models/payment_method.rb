class PaymentMethod < ApplicationRecord
  belongs_to :order
end
