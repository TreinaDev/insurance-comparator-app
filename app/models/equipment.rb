class Equipment < ApplicationRecord
  belongs_to :client
  has_one_attached :invoice
  has_many_attached :photos

end
