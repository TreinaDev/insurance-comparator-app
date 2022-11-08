class Equipment < ApplicationRecord
  has_one_attached :invoice
  has_many_attached :photos
  belongs_to :client
end
