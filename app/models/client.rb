class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :equipment, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :payments, dependent: nil
  before_validation :formatted_state

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :cpf, :address, :city, :state,
            :birth_date, presence: true
  validates :state, length: { is: 2 }, allow_blank: true
  validates :cpf, length: { is: 11 }, allow_blank: true
  validates :cpf, numericality: true, allow_blank: true
  validates :cpf, uniqueness: true
  validates :birth_date, comparison: { less_than: Time.zone.today }, allow_blank: true
  validates :name, :city, :state, :address, format: { with: /\p{Alpha}/ }, allow_blank: true

  def formatted_name_and_email
    "#{name} | #{email}"
  end

  def formatted_address
    "#{address} | #{city} - #{state}"
  end

  def formatted_state
    state.upcase! if state.present?
  end

  def formatted_cpf
    cpf.insert(3, '.')
    cpf.insert(7, '.')
    cpf.insert(11, '-')
  end
end
