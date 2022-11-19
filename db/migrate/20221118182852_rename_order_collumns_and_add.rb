class RenameOrderCollumnsAndAdd < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders, :price_percentage, :price
    change_column :orders, :price, :decimal
    rename_column :orders, :insurance_model, :product_model
    rename_column :orders, :insurance_id, :insurance_company_id
    rename_column :orders, :packages, :package_name
    rename_column :orders, :total_price, :final_price
    change_column :orders, :final_price, :decimal
    add_column :orders, :voucher, :decimal
    add_column :orders, :code, :string
    add_column :orders, :max_period, :integer
    add_column :orders, :min_period, :integer
    add_column :orders, :product_category, :string
    add_column :orders, :product_category_id, :string
  end
end
