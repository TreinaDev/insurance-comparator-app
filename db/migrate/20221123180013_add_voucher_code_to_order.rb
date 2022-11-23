class AddVoucherCodeToOrder < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders, :voucher, :voucher_price
    add_column :orders, :voucher_code, :string
  end
end
