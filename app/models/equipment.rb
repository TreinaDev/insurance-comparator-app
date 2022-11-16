class Equipment < ApplicationRecord
  has_one_attached :invoice
  has_many_attached :photos
  belongs_to :client

  validates :name, :brand, :purchase_date, :invoice, :photos, :equipment_price, presence: true
  validates :photos, length: { minimum: 2 }
  validate :purchase_date_is_past
  validates :equipment_price, comparison: { greater_than: 0 }, allow_blank: true

  def purchase_date_is_past
    errors.add(:purchase_date, ' deve ser passada.') if purchase_date.present? && purchase_date > Time.zone.today
  end
end
