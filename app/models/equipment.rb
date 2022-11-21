class Equipment < ApplicationRecord
  has_one_attached :invoice
  has_many_attached :photos
  belongs_to :client
  has_many :orders, through: :client

  validates :name, :brand, :purchase_date, :invoice, :photos, :equipment_price, presence: true
  validate :photos_length
  validate :purchase_date_is_past
  validates :equipment_price, comparison: { greater_than: 0 }, allow_blank: true

  def photos_length
    errors.add(:base, 'Deve haver ao menos 2 fotos do produto') if !photos.attached? || photos.length < 2
  end

  def purchase_date_is_past
    errors.add(:purchase_date, ' deve ser passada.') if purchase_date.present? && purchase_date > Time.zone.today
  end
end
