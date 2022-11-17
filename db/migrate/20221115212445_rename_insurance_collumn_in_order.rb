class RenameInsuranceCollumnInOrder < ActiveRecord::Migration[7.0]
  def change
    rename_column :orders, :contract_price, :price_percentage
    add_column :orders, :total_price, :integer
  end
end
