class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.references :client, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.integer :payment_method_id
      t.integer :parcels
      t.integer :status, default: 0
      t.string :invoice_token

      t.timestamps
    end
  end
end
