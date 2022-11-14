class AddCollumnsToOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :payment_method, :integer
    add_column :orders, :contract_period, :integer
    add_column :orders, :contract_price, :decimal
    add_column :orders, :coverage, :string
    add_reference :orders, :equipment, null: false, foreign_key: true
  end
end
