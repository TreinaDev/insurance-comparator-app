class CreatePaymentMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_methods do |t|
      t.string :card_number
      t.string :card_brand
      t.string :boleto_number
      t.string :pix_code
      t.references :order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
