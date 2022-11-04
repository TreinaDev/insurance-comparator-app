class Client < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :cpf, :address, :city, :state, 
            :birth_date, presence: true  
  validates :state, length: { is: 2 }
  validates :cpf, length: { is: 11 }
  
end
