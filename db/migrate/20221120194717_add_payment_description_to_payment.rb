class AddPaymentDescriptionToPayment < ActiveRecord::Migration[7.0]
  def change
    add_column :payments, :payment_description, :string
  end
end
